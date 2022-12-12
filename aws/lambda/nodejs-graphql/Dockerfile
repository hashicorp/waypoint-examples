# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

###########
# Builder #
###########
FROM public.ecr.aws/lambda/nodejs:14 as BUILDER

WORKDIR /var/task
COPY index.js package*.json ./

RUN npm install npm@latest -g
RUN npm install
RUN npm prune --production

###########
# Runtime #
###########
FROM public.ecr.aws/lambda/nodejs:14

WORKDIR /var/task
COPY --from=BUILDER /var/task ./

CMD [ "index.handler" ]