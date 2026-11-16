# Postgres pelo podman (dados no volume pgdata):
#   podman run -d --name pg -e POSTGRES_PASSWORD=postgres \
#     -p 127.0.0.1:5432:5432 -v pgdata:/var/lib/postgresql/data \
#     docker.io/library/postgres:18
#   podman start pg / podman stop pg
# No pgAdmin, Register → Server: host localhost, porta 5432, usuário postgres,
# senha postgres. No terminal: podman exec -it pg psql -U postgres
{
  den.aspects.pgadmin = {
    nixos = {
      services.flatpak.packages = [ "org.pgadmin.pgadmin4" ];
    };
  };
}
