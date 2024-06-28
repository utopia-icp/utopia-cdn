# Usage

```
REGISTRY_PATH='path/to/registry.proto'
OUTPUT_PATH='path/to/init.bin'

cargo run -- \
    --registry ${REGISTRY_PATH} \
    --out ${OUTPUT_PATH}
```

# Convert to base64 (for dfx)

```
cat init.bin | xxd -p | tr -d '\n'
```

# Inspect with `didc`

```
cat init.bin | xxd -p | tr -d '\n' | didc decode
```
