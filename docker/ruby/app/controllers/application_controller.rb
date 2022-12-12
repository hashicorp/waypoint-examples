# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
