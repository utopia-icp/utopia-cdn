use std::{
    fs,
    io::{stdout, Write},
    path::PathBuf,
};

use anyhow::{Context, Error};
use candid::{CandidType, Deserialize, Encode};
use clap::Parser;
use ic_interfaces_registry::{
    RegistryDataProvider, RegistryVersionedRecord, ZERO_REGISTRY_VERSION,
};
use ic_registry_proto_data_provider::ProtoRegistryDataProvider;
use ic_registry_transport::pb::v1::{
    registry_mutation::Type, RegistryAtomicMutateRequest, RegistryMutation,
};

#[derive(Debug, Parser)]
struct Cli {
    /// Path to Protobuf registry file (e.g registry.proto)
    #[clap(long)]
    registry: PathBuf,

    /// Optional path to output init arg blob
    #[clap(long)]
    out: Option<PathBuf>,
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    let cli = Cli::parse();

    let r = ProtoRegistryDataProvider::load_from_file(cli.registry);

    let us = r
        .get_updates_since(ZERO_REGISTRY_VERSION)
        .context("failed to obtain registry updates")?;

    let ms = us
        .into_iter()
        .filter(|u| u.is_some())
        .map(record_to_mutation)
        .collect::<Vec<RegistryMutation>>();

    if ms.is_empty() {
        panic!("empty registry");
    }

    let mreq = RegistryAtomicMutateRequest {
        mutations: ms,
        ..Default::default()
    };

    let p = Payload {
        mutations: vec![mreq],
    };

    let out = Encode!(&p).context("failed to encode payload")?;

    if let Some(path) = cli.out {
        fs::write(path, out).context("failed to write output to file")?;
        return Ok(());
    }

    stdout()
        .write_all(&out)
        .context("failed to write output to stdout")?;

    Ok(())
}

#[derive(CandidType, Deserialize)]
struct Payload {
    mutations: Vec<RegistryAtomicMutateRequest>,
}

fn record_to_mutation(r: RegistryVersionedRecord<Vec<u8>>) -> RegistryMutation {
    let mut m = RegistryMutation::default();

    m.set_mutation_type(Type::Insert);
    m.key = r.key.as_bytes().to_vec();
    m.value = r.value.expect("missing value");

    m
}
