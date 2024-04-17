#!/bin/bash
set -ueo pipefail
cd "$(dirname "$0")/../.."

set -x
grep -q 'usesJavaScriptKitMockOnMac = false' Package.swift
grep -q 'usesLocalJavaScriptKit = false' Package.swift
