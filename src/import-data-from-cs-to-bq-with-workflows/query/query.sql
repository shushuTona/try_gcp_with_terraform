BEGIN
  BEGIN TRANSACTION;

  DELETE FROM `composed-facet-402402.import_data_from_cs_to_bq_with_workflows.test_table`
    WHERE id in (
      SELECT
        id
      FROM
        `composed-facet-402402.import_data_from_cs_to_bq_with_workflows.test_tmp_table`
    );

  INSERT INTO `composed-facet-402402.import_data_from_cs_to_bq_with_workflows.test_table` (SELECT id, name, age, created_at FROM `composed-facet-402402.import_data_from_cs_to_bq_with_workflows.test_tmp_table`);

  COMMIT TRANSACTION;

  DROP TABLE `composed-facet-402402.import_data_from_cs_to_bq_with_workflows.test_tmp_table`;

  EXCEPTION WHEN ERROR THEN
    ROLLBACK TRANSACTION;
END;