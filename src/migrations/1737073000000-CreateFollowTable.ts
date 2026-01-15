import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class CreateFollowTable1737073000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'follows',
        columns: [
          {
            name: 'id',
            type: 'integer',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'increment',
          },
          {
            name: 'followerId',
            type: 'integer',
            isNullable: false,
          },
          {
            name: 'followingId',
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
      'follows',
      new TableForeignKey({
        columnNames: ['followerId'],
        referencedColumnNames: ['id'],
        referencedTableName: 'users',
        onDelete: 'NO ACTION',
      })
    );

    await queryRunner.createForeignKey(
      'follows',
      new TableForeignKey({
        columnNames: ['followingId'],
        referencedColumnNames: ['id'],
        referencedTableName: 'users',
        onDelete: 'NO ACTION',
      })
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.getTable('follows');
    const followerForeignKey = table?.foreignKeys.find(
      (fk) => fk.columnNames.indexOf('followerId') !== -1
    );
    if (followerForeignKey) {
      await queryRunner.dropForeignKey('follows', followerForeignKey);
    }
    const followingForeignKey = table?.foreignKeys.find(
      (fk) => fk.columnNames.indexOf('followingId') !== -1
    );
    if (followingForeignKey) {
      await queryRunner.dropForeignKey('follows', followingForeignKey);
    }
    await queryRunner.dropTable('follows');
  }
}
