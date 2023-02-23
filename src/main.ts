import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { KafkaClient, Consumer, Message } from 'kafka-node';

const client = new KafkaClient({ kafkaHost: '127.0.0.1:9091' });
const consumer = new Consumer(client, [{ topic: 'messages.basic' }], {
  autoCommit: true,
});

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3001);
  consumer.on('message', async (message: Message) => console.log(message));
}
bootstrap();
