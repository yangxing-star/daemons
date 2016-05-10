Sneakers.configure  heartbeat: 1000,
                    amqp: ENV['amqp'],
                    vhost: '/',
                    exchange: 'sneakers',
                    exchange_type: :direct,
                    daemonize: false,
                    env: Padrino.env,
                    workers: 1,
                    pid_path: 'tmp/pids/sneakers.pid',
                    log: 'log/sneakers.log',
                    timeout_job_after: 5,
                    prefetch: 10,
                    threads: 10,
                    durable: true,
                    ack: true

Sneakers.logger.level = Logger::INFO

$publisher_pool = ConnectionPool.new(size: 5, timeout: 5) do
  Sneakers::Publisher.new
end