FROM debian:bullseye
RUN apt-get update -qq && apt-get install -qq -yy make curl gcc g++ patch bzip2 git unzip
RUN adduser --disabled-password --gecos '' --shell /bin/bash opam
USER opam
COPY --chown=opam:opam . /src
WORKDIR /src
RUN make cold
USER root
RUN install ./opam /usr/local/bin/
USER opam
ENV OPAMREPOSHA 26770281fa1ea8b13aab979c1dfbd326e9ab512c
RUN git clone https://github.com/ocaml/opam-repository --depth 1
RUN git -C opam-repository fetch origin $OPAMREPOSHA
RUN git -C opam-repository checkout $OPAMREPOSHA
RUN opam init -n --disable-sandboxing ./opam-repository
RUN find "$(pwd)/opam-repository" -name opam -type f > /home/opam/all-opam-files
