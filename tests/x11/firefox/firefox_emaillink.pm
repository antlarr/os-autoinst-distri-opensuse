# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2019 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Firefox emaillink test (Case#1436117)
# Maintainer: wnereiz <wnereiz@github>

use strict;
use warnings;
use base "x11test";
use testapi;
use utils;
use version_utils 'is_sle';

sub run {
    my ($self) = @_;
    my $next_key = "alt-o";

    if (is_sle('12-SP2+')) {
        $next_key = "alt-n";
    }

    $self->start_firefox_with_profile;

    # Email link
    send_key "alt-f";
    wait_still_screen 3;
    send_key "e";
    assert_screen(['firefox-email_link-welcome', 'firefox-email-mutt', 'firefox-email_link-send'], 90);
    if (match_has_tag('firefox-email-mutt')) {
        if (is_sle('<=12-sp2')) {
            record_soft_failure 'bsc#1131297';
        }
        else {
            send_key 'y';    # yes
            sleep 1;
            type_string "test\@suse.com\n";
            sleep 1;
            send_key 'home';      # beginning of subject
            sleep 1;
            send_key 'ctrl-k';    # delete existing subject
            sleep 1;
            type_string "test subject\n";
            sleep 1;
            send_key 'd';
            sleep 1;
            send_key 'd';
            sleep 1;
            send_key 'i';         # enter vim insert mode
            sleep 1;
            type_string "test email\n";
            sleep 1;
            send_key 'esc';       # escape insert mode
            sleep 1;
            save_screenshot;
            type_string ":wq\n";
            sleep 1;
            assert_screen('mutt-send');
            send_key 'y';
        }
    }
    elsif (match_has_tag('firefox-email_link-welcome')) {
        send_key $next_key;

        wait_still_screen 3;
        send_key $next_key;

        wait_still_screen 3;
        send_key "alt-a";
        type_string 'test@suse.com';
        send_key $next_key;

        sleep 1;
        send_key "alt-s";    #Skip

        assert_screen('firefox-email_link-settings_receiving', 90);
        send_key "alt-s";    #Server
        type_string "imap.suse.com";
        send_key "alt-n";    #Username
        type_string "test";
        if (is_sle('12-SP2+')) {
            assert_and_click "evolution-option-next";
            wait_still_screen 3;
            assert_and_click "evolution-option-next";
        }
        else {
            send_key $next_key;
            wait_still_screen 3;
            send_key $next_key;
        }

        assert_screen('firefox-email_link-settings_sending');
        send_key "alt-s";    #Server
        type_string "smtp.suse.com";
        wait_screen_change {
            send_key $next_key;
        };

        wait_still_screen 3;
        if (is_sle('12-SP2+')) {
            assert_and_click "evolution-option-next";
        }
        else {
            send_key $next_key;
        }

        wait_still_screen 3;
        send_key "alt-a";
        assert_screen('firefox-email_link-send');
    }
    elsif (match_has_tag('firefox-email_link-send')) {
        wait_screen_change {
            send_key 'esc';
        };
    }

    $self->exit_firefox;
}
1;
