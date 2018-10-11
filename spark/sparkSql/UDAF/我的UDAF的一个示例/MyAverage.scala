package udaf

import org.apache.spark.sql.{Row, SparkSession}
import org.apache.spark.sql.expressions.{MutableAggregationBuffer, UserDefinedAggregateFunction}
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._
/**
  * Created by Administrator on 2018/9/6 0006.
  */
class MyAverage  extends  UserDefinedAggregateFunction{
//  必须加上::Nil
  def inputSchema: StructType = StructType(StructField("inputColumn", LongType) :: Nil)

  def bufferSchema: StructType = StructType(StructField("sum", LongType)::StructField("count", LongType) :: Nil)

  def dataType: DataType = DoubleType

  def deterministic: Boolean = true

  def initialize(buffer: MutableAggregationBuffer): Unit = {
    buffer(0) = 0L
    buffer(1) = 0L
  }

  //相当于combine过程， 而且是map端的
  def update(buffer: MutableAggregationBuffer, input: Row): Unit = {
    if (!input.isNullAt(0)) {
      buffer(0) = buffer.getLong(0) + input.getLong(0)
      buffer(1) = buffer.getLong(1) + 1
    }
  }

//  这个是reduce阶段，这个buffer2:Row是什么鬼
  def merge(buffer1: MutableAggregationBuffer, buffer2: Row): Unit = {
    //不同分区的sum之间，使用加法， 得到buffer1(0), 相当于rdd中的reduce操作
    buffer1(0) = buffer1.getLong(0) + buffer2.getLong(0)
    //不同分区的count之间，使用加法， 得到buffer1(0), 相当于rdd中的reduce操作
    buffer1(1) = buffer1.getLong(1) + buffer2.getLong(1)
  }

  def evaluate(buffer: Row): Double = buffer.getLong(0).toDouble / buffer.getLong(1)
}

case class employee(name: String, salary: Int)

object MyAverage{
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder().master("local[*]").appName("avg").getOrCreate()

    import spark.implicits._

    val df = Seq(
      employee("Michael", 3000),
      employee("Andy", 4500),
      employee("Andy", 3500),
      employee("Berta", 4000)
    ).toDS().toDF("name1","salary1")

//    import spark.implicits._
    val obj = new MyAverage
    val df1 = df.select(obj.apply(col("salary1")))
//返回结果————————这是未分组的求平均值
//      +------------------+
//     |myaverage(salary1)|
//    +------------------+
//   |            3750.0|
//  +------------------+
    df1.show

//    将汇总函数用于“分组”汇总
    val df2 = df.groupBy("name1").agg(obj.apply(col("salary1")))

    df2.show()
//分组求平均的结果：
//      +-------+------------------+
//      |  name1|myaverage(salary1)|
//      +-------+------------------+
//      |Michael|            3000.0|
//      |   Andy|            4000.0|
//      |  Berta|            4000.0|
//      +-------+------------------+

  }
}