import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from './User';

@Entity('follows')
export class Follow {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'followerId' })
  follower: User;

  @Column({ type: 'integer' })
  followerId: number;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'followingId' })
  following: User;

  @Column({ type: 'integer' })
  followingId: number;

  @CreateDateColumn()
  createdAt: Date;
}
