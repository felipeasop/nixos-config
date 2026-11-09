{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings = {
        system.monitor = {
          enabled = true;
          cpu_poll_seconds = 2.0;
          cpu_temp_sensor_path = "";
          cpu_temp_activity_threshold = 60.0;
          cpu_temp_critical_threshold = 85.0;
          cpu_usage_activity_threshold = 50.0;
          cpu_usage_critical_threshold = 90.0;
          disk_poll_seconds = 10.0;
          disk_used_pct_activity_threshold = 80.0;
          disk_used_pct_critical_threshold = 95.0;
          gpu_poll_seconds = 5.0;
          gpu_temp_activity_threshold = 60.0;
          gpu_temp_critical_threshold = 85.0;
          gpu_usage_activity_threshold = 50.0;
          gpu_usage_critical_threshold = 95.0;
          gpu_vram_activity_threshold = 50.0;
          gpu_vram_critical_threshold = 90.0;
          memory_poll_seconds = 2.0;
          ram_pct_activity_threshold = 60.0;
          ram_pct_critical_threshold = 90.0;
          swap_pct_activity_threshold = 20.0;
          swap_pct_critical_threshold = 80.0;
          network_poll_seconds = 3.0;
          net_rx_activity_threshold = 1.0;
          net_rx_critical_threshold = 50.0;
          net_tx_activity_threshold = 1.0;
          net_tx_critical_threshold = 50.0;
        };
      };
    };
  };
}
