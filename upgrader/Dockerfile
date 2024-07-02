FROM --platform=linux/amd64 ubuntu:24.04

COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/

RUN apt update && apt install -y jq libunwind-dev

# Replica version

ARG IC_COMMIT='b9a0f18dd5d6019e3241f205de797bca0d9cc3f8'

# Scripts, config files, and node container tarball

COPY ./upgrader.sh /workspace/upgrader.sh
RUN echo "${IC_COMMIT}" > /workspace/version.txt
COPY ./node.tar /workspace/node.tar

ENTRYPOINT ["/workspace/upgrader.sh"]
