import { Request } from 'express';

declare module 'express-serve-static-core' {
  interface Request {
    user?: string; // Type for user ID or adapt as needed
    token?: string; // Type for token if you need it
  }
}
