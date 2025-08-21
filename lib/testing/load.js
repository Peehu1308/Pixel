import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
  vus: 500,        // 500 virtual users
  duration: '1m',  // run for 1 minute
};

export default function () {
  http.post('https://your-api.com/auth/login', JSON.stringify({
    email: "test@example.com",
    password: "123456"
  }), { headers: { "Content-Type": "application/json" }});

  http.get('https://your-api.com/messages');
  sleep(1);
}
