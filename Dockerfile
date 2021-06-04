#################
#
# Because Composer is organized as a monorepo with multiple packages
# managed by yarn workspaces, our Dockerfile may not look like other
# node / react projects. Specifically, we have to add all source files
# before doing yarn install due to yarn workspace symlinking.
#
################
FROM  mcr.microsoft.com/dotnet/core/sdk:3.1-focal as base
RUN apt update \
    && apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt install -y nodejs libgomp1 \
    && npm install -g yarn

FROM base as build

WORKDIR /
COPY . .
# run yarn install as a distinct layer
RUN yarn install --frozen-lock-file 
ENV NODE_ENV "production"
RUN yarn build 
CMD ["yarn","start"]
