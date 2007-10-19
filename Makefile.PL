use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Catalyst::Plugin::Alarm',
    VERSION_FROM      => 'Alarm.pm',
    PREREQ_PM         => {
                     'Sys::SigAction' => 0.04, 
                     'Time::HiRes'    => 1.0,
                     'Class::Accessor::Fast' => 0,
                     'Catalyst::Runtime'     => 5.7,

                     }, 
    AUTHOR            => 'Peter Karman <pkarman@atomiclearning.com>',
    dist              => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean             => { FILES => 'Catalyst-Plugin-Alarm-*' },

);
