function start_puppet_agent {
        MASTER_PORT=18140
        $BIN/puppet agent --vardir /tmp/puppet-$$ --confdir /tmp/puppet-$$ --rundir /tmp/puppet-$$ \
                --no-daemonize --onetime --server localhost --debug --masterport $MASTER_PORT "$@"
}

function start_puppet_master {
        MASTER_PORT=18140
        mkdir -p /tmp/puppet-$$/manifests/
        $BIN/puppet master --vardir /tmp/puppet-$$ --confdir /tmp/puppet-$$ --rundir /tmp/puppet-$$ \
                --no-daemonize --autosign=true --certname=localhost --masterport $MASTER_PORT "$@" &
        MASTER_PID=$!

        for I in `seq 0 10` ; do
                if lsof -i -n -P | grep '\*:'$MASTER_PORT | grep $MASTER_PID > /dev/null ; then
                        break
                else
                        sleep 1
                fi
        done

}

function stop_puppet_master {
        kill $MASTER_PID
}