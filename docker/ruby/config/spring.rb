# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
].each { |path| Spring.watch(path) }
