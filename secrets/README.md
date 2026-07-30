# secrets/

Segredos cifrados com [sops-nix](https://github.com/Mic92/sops-nix), usando
`age`. A chave de cifragem/decifragem de cada host é derivada
automaticamente da chave de host SSH que o NixOS já gera sozinho
(`/etc/ssh/ssh_host_ed25519_key`) — não existe "chave mestra" separada
pra perder ou vazar.

Cada host tem sua PRÓPRIA chave SSH pessoal (ex: pra autenticar no
GitHub), gerada uma vez e cifrada aqui. Isso é mais seguro que
compartilhar a mesma chave entre máquinas: se um laptop for perdido/roubado,
você revoga só a deploy key dele no GitHub, sem precisar trocar a de
todas as outras máquinas.

## Ferramentas necessárias (uma vez, em qualquer máquina com Nix)

```sh
nix shell nixpkgs#sops nixpkgs#age nixpkgs#ssh-to-age
```

## Passo a passo: gerar chave SSH pra um host novo

Exemplo pro host `laptop`, usuário `flp`. Repita trocando os nomes pra
cada host novo.

### 1. Gerar o par de chaves SSH

```sh
ssh-keygen -t ed25519 -C "flp@laptop" -f /tmp/laptop_id_ed25519 -N ""
```

### 2. Pegar a chave pública `age` do host (derivada da chave SSH do host)

Rodar **no próprio host**, já com NixOS instalado (a chave de host SSH só
existe depois da primeira instalação):

```sh
nix shell nixpkgs#ssh-to-age --command sh -c \
  'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
```

Anota o valor `age1...` impresso.

### 3. Registrar o destinatário em `.sops.yaml` (raiz do repo)

```yaml
keys:
  - &atlas age1le2a7zv6ln9h34znl74qg7w86ntlzf9wr9f9p7rlu4pyqxmrud2qk24rpk
  - &laptop age1...   # cole aqui o valor do passo 2

creation_rules:
  - path_regex: secrets/secrets\.yaml$
    key_groups:
      - age:
          - *atlas
          - *laptop
```

### 4. Editar o arquivo cifrado

```sh
cd ~/nixos-config
sops secrets/secrets.yaml
```

Adicionar uma entrada nova, seguindo o padrão já existente:

```yaml
ssh:
  atlas:
    private_key: |
      -----BEGIN OPENSSH PRIVATE KEY-----
      ...
      -----END OPENSSH PRIVATE KEY-----
    public_key: "ssh-ed25519 AAAA... flp@atlas"
  laptop:
    private_key: |
      -----BEGIN OPENSSH PRIVATE KEY-----
      ... cole aqui o conteúdo de /tmp/laptop_id_ed25519 ...
      -----END OPENSSH PRIVATE KEY-----
    public_key: "ssh-ed25519 AAAA... flp@laptop"
```

Salvar e fechar o editor — `sops` cifra e grava automaticamente. O
arquivo já cifrado é seguro pra commitar.

### 5. Apagar a chave temporária

```sh
shred -u /tmp/laptop_id_ed25519 /tmp/laptop_id_ed25519.pub
```

### 6. Incluir o aspect no host

Em `modules/hosts/laptop/default.nix`, adicionar aos `includes`:

```nix
includes = with den.aspects; [
  # ...
  secrets
  (ssh-identity-for { user = "flp"; })
];
```

A chave usada em `secrets/secrets.yaml` (`ssh.<hostname>.*`) casa
automaticamente com `config.networking.hostName` do host — não precisa
declarar o nome do host de novo em nenhum outro lugar.

### 7. Rebuild e cadastrar no GitHub

```sh
rebuild
cat ~/.ssh/id_ed25519.pub
```

Copia a saída e cadastra em https://github.com/settings/keys.

## Editar um segredo existente

```sh
sops secrets/secrets.yaml
```
