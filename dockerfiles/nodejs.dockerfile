ARG NODEJS_VERSION=8.12
FROM node:${NODEJS_VERSION}-alpine as nodejs

FROM kubox:base
RUN apk add --no-cache libstdc++
COPY --from=nodejs /usr/local/ /usr/local/
COPY --from=nodejs /opt/ /opt/
