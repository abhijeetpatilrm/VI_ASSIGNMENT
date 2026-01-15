import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class CreatePostHashtagTable1737076000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'post_hashtags',
        columns: [
          {
            name: 'id',
            type: 'integer',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'increment',
          },
          {
            name: 'postId',
            type: 'integer',
            isNullable: false,
          },
          {
            name: 'hashtagId',
            type: 'integer',
            isNullable: false,
          },
          {
            name: 'createdAt',
            type: 'datetime',
            default: 'CURRENT_TIMESTAMP',
          },
        ],
      }),
      true
    );

    await queryRunner.createForeignKey(
      'post_hashtags',
      new TableForeignKey({
        columnNames: ['postId'],
        referencedColumnNames: ['id'],
        referencedTableName: 'posts',
        onDelete: 'NO ACTION',
      })
    );

    await queryRunner.createForeignKey(
      'post_hashtags',
      new TableForeignKey({
        columnNames: ['hashtagId'],
        referencedColumnNames: ['id'],
        referencedTableName: 'hashtags',
        onDelete: 'NO ACTION',
      })
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.getTable('post_hashtags');
    const postForeignKey = table?.foreignKeys.find(
      (fk) => fk.columnNames.indexOf('postId') !== -1
    );
    if (postForeignKey) {
      await queryRunner.dropForeignKey('post_hashtags', postForeignKey);
    }
    const hashtagForeignKey = table?.foreignKeys.find(
      (fk) => fk.columnNames.indexOf('hashtagId') !== -1
    );
    if (hashtagForeignKey) {
      await queryRunner.dropForeignKey('post_hashtags', hashtagForeignKey);
    }
    await queryRunner.dropTable('post_hashtags');
  }
}
