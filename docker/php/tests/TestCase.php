<?php
// Copyright (c) HashiCorp, Inc.
// SPDX-License-Identifier: MPL-2.0


namespace Tests;

use Illuminate\Foundation\Testing\TestCase as BaseTestCase;

abstract class TestCase extends BaseTestCase
{
    use CreatesApplication;
}
