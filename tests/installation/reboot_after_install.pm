# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# G-Summary: add random reboot after install
# G-Maintainer: Bernhard M. Wiedemann <bernhard+osautoinst lsmod de>

use base "installbasetest";
use strict;
use testapi;

sub run() {
    my $self = shift;

    assert_screen "reboot_after_install", 200;
}

1;
# vim: set sw=4 et:
