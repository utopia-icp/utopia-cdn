use ic_config::metrics::Exporter;
use ic_config::Config;

fn main() {
    let mut config = Config::new(std::path::PathBuf::from("/workspace/node"));
    config.adapters_config.https_outcalls_uds_path = Some(std::path::PathBuf::from(
        "/workspace/ic-https-outcalls-adapter/socket",
    ));
    config.message_routing.xnet_ip_addr = "::".to_string();
    config.message_routing.xnet_port = 2497;
    config.metrics.exporter = Exporter::Http("[::]:9090".parse().unwrap());
    config.registry_client.local_store =
        std::path::PathBuf::from("/workspace/node/ic_registry_local_store");
    config.transport.node_ip = "::".to_string();
    config.transport.listening_port = 4100;
    println!("{}", serde_json::to_string(&config).unwrap());
}
