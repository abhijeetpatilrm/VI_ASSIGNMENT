import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Post } from './Post';
import { Hashtag } from './Hashtag';

@Entity('post_hashtags')
export class PostHashtag {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @ManyToOne(() => Post)
  @JoinColumn({ name: 'postId' })
  post: Post;

  @Column({ type: 'integer' })
  postId: number;

  @ManyToOne(() => Hashtag)
  @JoinColumn({ name: 'hashtagId' })
  hashtag: Hashtag;

  @Column({ type: 'integer' })
  hashtagId: number;

  @CreateDateColumn()
  createdAt: Date;
}
