package TestApp;
use strict;
use warnings;

use Test::More tests => 9;

use Catalyst qw[ Alarm];
__PACKAGE__->config(
    alarm => {
        timeout => 3,
        handler => sub {
            if (ref $_[1])
            {
                diag(" .... local alarm went off!!");
                $_[1]->[0] = 1;
                $_[0]->alarm->on(0);
            }
            else
            {
                diag(" .... global alarm went off");

                #$_[0]->alarm->on(0);   # leave it on to test
            }
        },
        global => 5
             }
);
__PACKAGE__->setup();

# apologies to Woody Allen
sub sleeper : Local
{
    my ($self, $c, $l) = @_;
    $l ||= 0;
    sleep $l;

    $c->response->output('ok');

    $self->clear($c);
}

sub foo : Global
{
    my ($self, $c) = @_;

    can_ok($c, 'alarm');

    # long doesn't use sleep()
    ok($c->timeout('long', [10000000]), "long");

    $self->clear($c);

    ok($c->timeout(action => ['sleeper', [2]], timeout => 1),
        "sleeper with args");

    $self->clear($c);

    ok($c->timeout({action => [qw/TestApp sleeper/, [2]], timeout => 1}),
        "sleeper with everything");

    $self->clear($c);

    # force global alarm to go off
    sleep $c->config->{alarm}->{global};

    ok($c->alarm->on, "global alarm sounded");

    $self->clear($c);

}

sub long : Local
{
    my ($self, $c, $top) = @_;
    my $l = 0;
    $top ||= 100000;
    while ($l++ < $top)
    {
        1;

        #carp $l unless $l % 100;
    }

    $c->response->output("l = $l");

    $self->clear($c);
}

sub clear
{
    my ($self, $c) = @_;
    if (@{$c->error})
    {
    
        #warn ".......... found error ...........\n";
        
        my @e = @{$c->error};
        if (grep { m/Alarm/ } @e)
        {

            #$c->clear_errors;  # newer Cat versions have this
            $c->error(0);
        }
    }
    else
    {
        $c->log->debug("no error")
          if $c->debug;
    }
}

package main;
use Catalyst::Test 'TestApp';
use Test::More;

ok(get('/sleeper'),    "get /sleeper");
ok(get('/sleeper/10'), "get /sleeper/10");
ok(get('/long'),       "get /long");
ok(get('/foo'),        "get /foo");

1;

