FROM --platform=linux/amd64 ubuntu:24.04

COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/

RUN apt update && apt install -y jq libunwind-dev

# Replica version

ARG IC_COMMIT='ec35ebd252d4ffb151d2cfceba3a86c4fb87c6d6'

# Scripts, config files, and node container tarball

COPY ./upgrader.sh /workspace/upgrader.sh
RUN echo "${IC_COMMIT}" > /workspace/version.txt
COPY ./node.tar /workspace/node.tar

ENTRYPOINT ["/workspace/upgrader.sh"]
