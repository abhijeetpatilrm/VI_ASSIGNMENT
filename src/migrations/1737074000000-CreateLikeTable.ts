import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class CreateLikeTable1737074000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'likes',
        columns: [
          {
            name: 'id',
            type: 'integer',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'increment',
          },
          {
            name: 'userId',
            type: 'integer',
            isNullable: false,
          },
          {
            name: 'postId',
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
      'likes',
      new TableForeignKey({
        columnNames: ['userId'],
        referencedColumnNames: ['id'],
        referencedTableName: 'users',
        onDelete: 'NO ACTION',
      })
    );

    await queryRunner.createForeignKey(
      'likes',
      new TableForeignKey({
        columnNames: ['postId'],
        referencedColumnNames: ['id'],
        referencedTableName: 'posts',
        onDelete: 'NO ACTION',
      })
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.getTable('likes');
    const userForeignKey = table?.foreignKeys.find(
      (fk) => fk.columnNames.indexOf('userId') !== -1
    );
    if (userForeignKey) {
      await queryRunner.dropForeignKey('likes', userForeignKey);
    }
    const postForeignKey = table?.foreignKeys.find(
      (fk) => fk.columnNames.indexOf('postId') !== -1
    );
    if (postForeignKey) {
      await queryRunner.dropForeignKey('likes', postForeignKey);
    }
    await queryRunner.dropTable('likes');
  }
}
