package DbMonitor;

use strict;
use warnings;

use DBI;
use DbProc;
# use Data::Dumper;

# ----------------------------------------------------------------------------------------------------------------------

sub new {
    my ($class, $params) = @_;

    my $self;

    while (my ($k, $v) = each %{$params}) {
        $self->{ $k } = $v;
    }

    bless $self, $class;

    if ($self->{ 'log_conf_file' }) {
        use Log::Log4perl;
        use Data::Dumper;

        $self->{ 'logger' } = Log::Log4perl->get_logger();
        Log::Log4perl::init($self->{ 'log_conf_file' });
    }

    $self->{ 'db_proc' } = DbProc->new({
        'config'        => $self->{ 'config' },
        'tmpl_path'     => $self->{ 'tmpl_path' },
        'db_config'     => $self->{ 'db_config' },
        'monitor_name'  => $self->{ 'monitor_name' },
        'repeat_period' => $self->{ 'db_config' }->{ 'repeat_period' },
        'logger'        => $self->{ 'logger' },
        'job_queue'     => $self->{ 'job_queue' },
    });

    return $self;
}

# ----------------------------------------------------------------------------------------------------------------------

sub startMonitor{
    my ($self) = @_;

    $self->{ 'db_proc' }->startProc;

    return;
}

1;
