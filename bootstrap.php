<?php

require __DIR__ . '/vendor/autoload.php';

use Enqueue\RdKafka\RdKafkaConnectionFactory;

// connect to Kafka broker at example.com:1000 plus custom options
$connectionFactory = new RdKafkaConnectionFactory([
    'global' => [
        'group.id' => uniqid('', true),
        'metadata.broker.list' => 'rdkafka-kafka:29092',
        'enable.auto.commit' => 'false',
    ],
    'topic' => [
        'auto.offset.reset' => 'earliest',
    ],
]);

$context = $connectionFactory->createContext();

$fooTopic = $context->createTopic('event-tracking-topic');


for($i=0;$i<=100;$i++){

    $message = $context->createMessage(json_encode([
        'project' => 'DOGITAL_GOODS',
        'category' => 'APPLICATION',
        'name' => 'TRANSACTION_CREATE',
        'label' => 'LOG',
        'value' => rand(-10000, 9999),
        'properties' => [
            'browser' => 'mac-os',
            'authorized_push' => false,
            'authorized_gps' => false,
            'email_name' => 'adrianolaselva@gmail.com',
            'authorized_contacts' => false,
            'age' => 32,
            'blocked_user' => false,
        ],
    ]));

    $context
        ->createProducer()
        ->send($fooTopic, $message);
}

// if you have enqueue/enqueue library installed you can use a factory to build context from DSN
//$context = (new \Enqueue\ConnectionFactoryFactory())->create('kafka:')->createContext();
