<?php

require __DIR__ . '/vendor/autoload.php';


$connectionFactory = new Enqueue\RdKafka\RdKafkaConnectionFactory([
    'global' => [
//        'group.id' => uniqid('', true),
        'group.id' => 'php-poc-kafka',
        'metadata.broker.list' => 'rdkafka-kafka:29092',
        'enable.auto.commit' => 'false',
    ],
    'topic' => [
        'auto.offset.reset' => 'earliest',
    ],
]);

$context = $connectionFactory->createContext();

$queue = $context->createQueue('event-tracking-topic');
$consumer = $context->createConsumer($queue);
$consumer->setCommitAsync(true);

do {
    $message = $consumer->receive();

    printf("%s%s", $message->getBody(), PHP_EOL);

    $consumer->acknowledge($message);
} while(true);

