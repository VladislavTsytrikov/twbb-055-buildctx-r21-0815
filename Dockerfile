FROM alpine:3.20
RUN echo "TWBB_PR_BUILD_EXECUTED=1"; echo "TWBB_PR_MARKER=pull-request-code-ran"
