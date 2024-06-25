FROM --platform=linux/amd64 ubuntu:24.04

# binaries

ARG DFINITY_ARTIFACTS_URL='https://dfinity-download-public.s3.eu-central-1.amazonaws.com'

ARG IC_PREP_REF='ec35ebd252d4ffb151d2cfceba3a86c4fb87c6d6'
ADD ${DFINITY_ARTIFACTS_URL}/ic/${IC_PREP_REF}/release/ic-prep.gz .
RUN zcat ic-prep.gz > /usr/bin/ic-prep && chmod +x /usr/bin/ic-prep && rm ic-prep.gz

ENTRYPOINT [ "ic-prep" ]
