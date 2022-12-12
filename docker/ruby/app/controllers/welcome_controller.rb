# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

class WelcomeController < ApplicationController

  # GET /welcome
  def index
    @host = request.host_with_port
  end

end
