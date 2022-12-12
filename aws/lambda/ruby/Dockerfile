# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

FROM public.ecr.aws/lambda/ruby:2.7

COPY handler.rb /var/task

CMD [ "handler.handler" ]