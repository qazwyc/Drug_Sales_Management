<div id="article_content" class="article_content">
        <div class="markdown_views"><h2 id="开发环境和开发工具">开发环境和开发工具</h2>

<p>操作系统：win8.1 <br>
开发环境：Mysql、Web <br>
开发工具：Workbench、Eclipse、JDBC</p>

<h2 id="功能需求分析">功能需求分析</h2>

<ul>
<li>员工有权查看、添加会员，查看、添加供应商，查询药品（输入药品编号或名称、类别等查询该药品或该类药品库存），添加药品采购记录，销售药品，处理退货，盘点仓库，查看销售、退货、入库记录，修改个人信息</li>
<li>经理有权查看、添加、删除会员，查看、添加、删除供应商，查看、添加、删除员工，盘点仓库，查看销售、退货、入库记录，修改个人信息，无权进行销售和退货业务</li>
<li>供应商和顾客对此系统没有使用权限 系统设计</li>
</ul>

<p><img src="http://img.blog.csdn.net/20170302201547044?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""></p>

<h2 id="系统设计">系统设计</h2>

<ul>
<li>数据流 <br>
<img src="http://img.blog.csdn.net/20170302210109495?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""></li>
<li>E-R图 <br>
<img src="http://img.blog.csdn.net/20170302210142101?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""></li>
<li><p>数据库关系模式设计</p>

<p>登录用户（用户编号，用户名，密码，类别） <br>
员工（员工编号，员工姓名，联系电话，用户编号） <br>
经理（经理编号，用户编号） <br>
财政收支（收支编号，药品编号，员工编号，数量，日期，总额，类型） <br>
供应商（供应商编号，供应商名称，联系人，联系方式，所在城市） <br>
会员（客户编号，客户姓名，联系方式） <br>
入库记录（入库记录编号，供应商编号，收支编号） <br>
退货管理（退货编号，销售编号，收支编号） <br>
销售管理（销售编号，客户编号，收支编号） <br>
药品（药品编号，药品名称，供应商编号，生产批号，产地，所属类别，进价，单价，会员折扣，库存，包装规格，生产日期，有效期）</p></li>
<li><p>数据库物理结构设计</p>

<p>本次项目使用的引擎是InnoDB，MySQL的数据库引擎之一。InnoDB存储引擎为在主内存中缓存数据和索引而维持它自己的缓冲池。InnoDB存储它的表&amp;索引在一个表空间中，表空间可以包含数个文件（或原始磁盘分区）。这与MyISAM表不同，比如在MyISAM表中每个表被存在分离的文件中。InnoDB 表可以是任何尺寸，即使在文件尺寸被限制为2GB的操作系统上。InnoDB默认地被包含在MySQL二进制分发中。Windows Essentials installer使InnoDB成为Windows上MySQL的默认表。</p>

<p>此外还使用了数据库索引，索引是对数据库表中一列或多列的值进行排序的一种结构，使用索引可快速访问数据库表中的特定信息。各表索引如下： <br>
会员：primary key(客户编号) <br>
药品：primary key(药品编号), <br>
      INDEX <code>供应商编号_idx</code> (<code>供应商编号</code> ASC), <br>
供应商：primary key(供应商编号) <br>
登录用户：primary key(用户编号) <br>
                  用户名  unique, <br>
经理：primary key(经理编号), <br>
      INDEX <code>经理编号_idx</code> (<code>用户编号</code> ASC), <br>
员工：primary key(员工编号), <br>
      INDEX <code>员工编号_idx</code> (<code>用户编号</code> ASC), <br>
财政收支：PRIMARY KEY (<code>收支编号</code>), <br>
          INDEX <code>药品编号_idx</code> (<code>药品编号</code> ASC), <br>
          INDEX <code>员工编号_idx</code> (<code>员工编号</code> ASC), <br>
入库记录：primary key(入库记录编号), <br>
          INDEX <code>供应商编号_idx</code> (<code>供应商编号</code> ASC), <br>
          INDEX <code>收支编号_idx</code> (<code>收支编号</code> ASC), <br>
销售管理：PRIMARY KEY (<code>销售编号</code>), <br>
  INDEX <code>客户编号_idx</code> (<code>客户编号</code> ASC), <br>
          INDEX <code>收支编号_idx</code> (<code>收支编号</code> ASC), <br>
退货管理：PRIMARY KEY (<code>退货编号</code>), <br>
          INDEX <code>销售编号_idx</code> (<code>销售编号</code> ASC), <br>
          INDEX <code>收支编号_idx</code> (<code>收支编号</code> ASC),</p></li>
</ul>



<h2 id="系统功能的实现">系统功能的实现</h2>

<ul>
<li><p>建表</p>

<pre class="prettyprint"><code class=" hljs sql"><span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">database</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> 医药销售管理系统;</span>
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">database</span> 医药销售管理系统;</span>
use 医药销售管理系统;
//建立表 会员
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">table</span> <span class="hljs-string">`会员`</span>(
    客户编号      <span class="hljs-keyword">int</span> auto_increment,
    客户姓名      <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
    联系方式      <span class="hljs-keyword">varchar</span>(<span class="hljs-number">100</span>),
<span class="hljs-keyword">primary</span> <span class="hljs-keyword">key</span>(客户编号));</span>
//建立表 供应商
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">table</span> <span class="hljs-string">`供应商`</span>(
    供应商编号     <span class="hljs-keyword">int</span> auto_increment,
    供应商名称     <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
    联系人         <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
    联系方式       <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
    所在城市       <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
<span class="hljs-keyword">primary</span> <span class="hljs-keyword">key</span>(供应商编号));</span>
//建立表 药品
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">table</span> <span class="hljs-string">`药品`</span>(
    药品编号    <span class="hljs-keyword">int</span> auto_increment,
    药品名称    <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>) <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
    供应商编号  <span class="hljs-keyword">int</span> <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
    生产批号    <span class="hljs-keyword">varchar</span>(<span class="hljs-number">100</span>),
    产地        <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
    所属类别    <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
    进价        <span class="hljs-keyword">decimal</span>(<span class="hljs-number">10</span>,<span class="hljs-number">2</span>) <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
    单价        <span class="hljs-keyword">decimal</span>(<span class="hljs-number">10</span>,<span class="hljs-number">2</span>) <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
    会员折扣    <span class="hljs-keyword">decimal</span>(<span class="hljs-number">3</span>,<span class="hljs-number">2</span>),
    库存        <span class="hljs-keyword">int</span> <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
    包装规格    <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
    生产日期    <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
    有效期      <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
<span class="hljs-keyword">primary</span> <span class="hljs-keyword">key</span>(药品编号),
INDEX <span class="hljs-string">`供应商编号_idx`</span> (<span class="hljs-string">`供应商编号`</span> <span class="hljs-keyword">ASC</span>),
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`供应商编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`供应商编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`供应商`</span> (<span class="hljs-string">`供应商编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>);</span>
//建立表登录用户，可以登录医药销售管理系统，类别为1代表员工，2代表经理
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">table</span> <span class="hljs-string">`登录用户`</span>(
    用户编号         <span class="hljs-keyword">int</span> auto_increment,
    用户名          <span class="hljs-keyword">varchar</span>(<span class="hljs-number">40</span>) <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span> <span class="hljs-keyword">unique</span>,
    密码           <span class="hljs-keyword">varchar</span>(<span class="hljs-number">40</span>) <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
    类别             <span class="hljs-keyword">int</span> <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
<span class="hljs-keyword">primary</span> <span class="hljs-keyword">key</span>(用户编号));</span>
//建立表经理，具有登录用户编号，可登录系统
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">table</span> <span class="hljs-string">`经理`</span>(
    经理编号      <span class="hljs-keyword">int</span> auto_increment,
    用户编号      <span class="hljs-keyword">int</span> <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
<span class="hljs-keyword">primary</span> <span class="hljs-keyword">key</span>(经理编号),
INDEX <span class="hljs-string">`经理编号_idx`</span> (<span class="hljs-string">`用户编号`</span> <span class="hljs-keyword">ASC</span>),
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`经理登陆编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`用户编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`登录用户`</span> (<span class="hljs-string">`用户编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>);</span>
//建立表员工，具有登录用户编号，可登录系统
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">table</span> <span class="hljs-string">`员工`</span>(
    员工编号      <span class="hljs-keyword">int</span> auto_increment,
    员工姓名      <span class="hljs-keyword">varchar</span>(<span class="hljs-number">50</span>),
    联系电话      <span class="hljs-keyword">varchar</span>(<span class="hljs-number">100</span>),
    用户编号      <span class="hljs-keyword">int</span> <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
<span class="hljs-keyword">primary</span> <span class="hljs-keyword">key</span>(员工编号),
INDEX <span class="hljs-string">`员工编号_idx`</span> (<span class="hljs-string">`用户编号`</span> <span class="hljs-keyword">ASC</span>),
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`员工登陆编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`用户编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`登录用户`</span> (<span class="hljs-string">`用户编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>);</span>
//建立表财政开支，涉及药品编号、负责员工、数量、金额等信息，类型有入库、销售、退货等
<span class="hljs-operator"><span class="hljs-keyword">CREATE</span> <span class="hljs-keyword">TABLE</span> <span class="hljs-string">`财政收支`</span> (
<span class="hljs-string">`收支编号`</span> <span class="hljs-keyword">int</span> auto_increment,
<span class="hljs-string">`药品编号`</span> <span class="hljs-keyword">int</span>,
<span class="hljs-string">`员工编号`</span> <span class="hljs-keyword">int</span> <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
<span class="hljs-string">`数量`</span> <span class="hljs-keyword">int</span>,
<span class="hljs-string">`日期`</span> datetime <span class="hljs-keyword">NOT</span> <span class="hljs-keyword">NULL</span>,
<span class="hljs-string">`总额`</span> <span class="hljs-keyword">decimal</span>(<span class="hljs-number">10</span>,<span class="hljs-number">2</span>) <span class="hljs-keyword">NOT</span> <span class="hljs-keyword">NULL</span>,
<span class="hljs-string">`类型`</span> <span class="hljs-keyword">VARCHAR</span>(<span class="hljs-number">20</span>)  <span class="hljs-keyword">NOT</span> <span class="hljs-keyword">NULL</span>,
<span class="hljs-keyword">PRIMARY</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`收支编号`</span>),
INDEX <span class="hljs-string">`药品编号_idx`</span> (<span class="hljs-string">`药品编号`</span> <span class="hljs-keyword">ASC</span>),
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`药品编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`药品编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`药品`</span> (<span class="hljs-string">`药品编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>,
INDEX <span class="hljs-string">`员工编号_idx`</span> (<span class="hljs-string">`员工编号`</span> <span class="hljs-keyword">ASC</span>),
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`负责员工编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`员工编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`员工`</span> (<span class="hljs-string">`员工编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>);</span>
//建立表入库记录，包含供应商、收支编号
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">table</span> <span class="hljs-string">`入库记录`</span>(
    入库记录编号   <span class="hljs-keyword">int</span> auto_increment,
    供应商编号     <span class="hljs-keyword">int</span> <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
    收支编号       <span class="hljs-keyword">int</span> <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
<span class="hljs-keyword">primary</span> <span class="hljs-keyword">key</span>(入库记录编号),
INDEX <span class="hljs-string">`供应商编号_idx`</span> (<span class="hljs-string">`供应商编号`</span> <span class="hljs-keyword">ASC</span>),
INDEX <span class="hljs-string">`收支编号_idx`</span> (<span class="hljs-string">`收支编号`</span> <span class="hljs-keyword">ASC</span>),
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`入货供应商编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`供应商编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`供应商`</span> (<span class="hljs-string">`供应商编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>,
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`入库收支编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`收支编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`财政收支`</span> (<span class="hljs-string">`收支编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>);</span>
//建立表销售管理，包含客户、收支编号
<span class="hljs-operator"><span class="hljs-keyword">CREATE</span> <span class="hljs-keyword">TABLE</span> <span class="hljs-string">`销售管理`</span>(
<span class="hljs-string">`销售编号`</span> <span class="hljs-keyword">int</span> auto_increment,
<span class="hljs-string">`客户编号`</span> <span class="hljs-keyword">int</span>,
<span class="hljs-string">`收支编号`</span> <span class="hljs-keyword">int</span> <span class="hljs-keyword">not</span> <span class="hljs-keyword">null</span>,
<span class="hljs-keyword">PRIMARY</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`销售编号`</span>),
INDEX <span class="hljs-string">`客户编号_idx`</span> (<span class="hljs-string">`客户编号`</span> <span class="hljs-keyword">ASC</span>),
INDEX <span class="hljs-string">`收支编号_idx`</span> (<span class="hljs-string">`收支编号`</span> <span class="hljs-keyword">ASC</span>),
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`销售客户编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`客户编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`会员`</span> (<span class="hljs-string">`客户编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>,
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`销售收支编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`收支编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`财政收支`</span> (<span class="hljs-string">`收支编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>);</span>
//建立表退货管理，包含销售、收支编号
<span class="hljs-operator"><span class="hljs-keyword">CREATE</span> <span class="hljs-keyword">TABLE</span> <span class="hljs-string">`退货管理`</span> (
<span class="hljs-string">`退货编号`</span> <span class="hljs-keyword">int</span> auto_increment,
<span class="hljs-string">`销售编号`</span> <span class="hljs-keyword">int</span> <span class="hljs-keyword">NOT</span> <span class="hljs-keyword">NULL</span>,
<span class="hljs-string">`收支编号`</span> <span class="hljs-keyword">int</span> <span class="hljs-keyword">NOT</span> <span class="hljs-keyword">NULL</span>,
<span class="hljs-keyword">PRIMARY</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`退货编号`</span>),
INDEX <span class="hljs-string">`销售编号_idx`</span> (<span class="hljs-string">`销售编号`</span> <span class="hljs-keyword">ASC</span>),
INDEX <span class="hljs-string">`收支编号_idx`</span> (<span class="hljs-string">`收支编号`</span> <span class="hljs-keyword">ASC</span>),
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`退货销售编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`销售编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`销售管理`</span> (<span class="hljs-string">`销售编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>,
<span class="hljs-keyword">CONSTRAINT</span> <span class="hljs-string">`退货收支编号`</span>
<span class="hljs-keyword">FOREIGN</span> <span class="hljs-keyword">KEY</span> (<span class="hljs-string">`收支编号`</span>)
<span class="hljs-keyword">REFERENCES</span> <span class="hljs-string">`医药销售管理系统`</span>.<span class="hljs-string">`财政收支`</span> (<span class="hljs-string">`收支编号`</span>)
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">DELETE</span> <span class="hljs-keyword">CASCADE</span>
<span class="hljs-keyword">ON</span> <span class="hljs-keyword">UPDATE</span> <span class="hljs-keyword">CASCADE</span>);</span></code></pre></li>
<li><p>创建视图方便查询</p>

<pre class="prettyprint"><code class=" hljs sql">
<span class="hljs-comment">/*仓库*/</span>
<span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">view</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> warehouse;</span> 
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">view</span> warehouse <span class="hljs-keyword">as</span>
<span class="hljs-keyword">select</span> 药品编号,药品名称,供应商名称,生产批号,产地,所属类别,进价,单价,会员折扣,库存,包装规格,生产日期,有效期
<span class="hljs-keyword">from</span> 药品,供应商 <span class="hljs-keyword">where</span> 药品.供应商编号=供应商.供应商编号;</span> 
<span class="hljs-comment">/*入库记录*/</span>
<span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">view</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> InDrug_records;</span> 
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">view</span> InDrug_records <span class="hljs-keyword">as</span>
<span class="hljs-keyword">select</span> 入库记录编号,药品名称,供应商名称,员工姓名,数量,日期,总额 
<span class="hljs-keyword">from</span> 入库记录,供应商,财政收支,员工,药品
<span class="hljs-keyword">where</span> 入库记录.供应商编号=供应商.供应商编号 <span class="hljs-keyword">and</span> 入库记录.收支编号=财政收支.收支编号 <span class="hljs-keyword">and</span>
财政收支.员工编号=员工.员工编号 <span class="hljs-keyword">and</span> 财政收支.药品编号=药品.药品编号;</span>
<span class="hljs-comment">/*销售记录*/</span>
<span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">view</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> sales_records;</span> 
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">view</span> sales_records <span class="hljs-keyword">as</span>
<span class="hljs-keyword">select</span> 销售编号,药品.药品编号,药品名称,单价,会员折扣,库存,客户姓名,员工姓名,数量,日期,总额
<span class="hljs-keyword">from</span> 销售管理,会员,财政收支,员工,药品
<span class="hljs-keyword">where</span> 销售管理.客户编号=会员.客户编号 <span class="hljs-keyword">and</span> 销售管理.收支编号=财政收支.收支编号
<span class="hljs-keyword">and</span> 财政收支.员工编号=员工.员工编号 <span class="hljs-keyword">and</span> 财政收支.药品编号=药品.药品编号;</span>
<span class="hljs-comment">/*退货记录*/</span>
<span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">view</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> reject_records;</span>
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">view</span> reject_records <span class="hljs-keyword">as</span>
<span class="hljs-keyword">select</span> 退货编号,退货管理.销售编号,药品名称,客户姓名,员工姓名,数量,日期,总额
<span class="hljs-keyword">from</span> 退货管理,销售管理,会员,财政收支,员工,药品
<span class="hljs-keyword">where</span> 退货管理.销售编号=销售管理.销售编号 <span class="hljs-keyword">and</span> 销售管理.客户编号=会员.客户编号 
<span class="hljs-keyword">and</span> 退货管理.收支编号=财政收支.收支编号 <span class="hljs-keyword">and</span> 财政收支.员工编号=员工.员工编号 
<span class="hljs-keyword">and</span> 财政收支.药品编号=药品.药品编号;</span>
<span class="hljs-comment">/*员工信息*/</span>
<span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">view</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> employee_info;</span>
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">view</span> employee_info <span class="hljs-keyword">as</span>
<span class="hljs-keyword">select</span> 员工编号,员工姓名,联系电话,员工.用户编号,用户名 <span class="hljs-keyword">from</span> <span class="hljs-string">`员工`</span> <span class="hljs-keyword">natural</span> <span class="hljs-keyword">join</span> <span class="hljs-string">`登录用户`</span>;</span>
<span class="hljs-comment">/*收支记录*/</span>
<span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">view</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> financial_records;</span>
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">view</span> financial_records <span class="hljs-keyword">as</span>
<span class="hljs-keyword">select</span> 类型,药品名称,数量,日期,总额 
<span class="hljs-keyword">from</span> <span class="hljs-string">`财政收支`</span> <span class="hljs-keyword">left</span> <span class="hljs-keyword">join</span> <span class="hljs-string">`药品`</span> <span class="hljs-keyword">on</span> <span class="hljs-string">`财政收支`</span>.药品编号=<span class="hljs-string">`药品`</span>.<span class="hljs-string">`药品编号`</span>;</span></code></pre></li>
<li><p>使用过程实现“带参数的视图“</p>

<pre class="prettyprint"><code class=" hljs sql"><span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">procedure</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> payments_statistics;</span>
delimiter //
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">procedure</span> payments_statistics(<span class="hljs-keyword">in</span> date_limit <span class="hljs-keyword">varchar</span>(<span class="hljs-number">20</span>))
<span class="hljs-keyword">begin</span>
    <span class="hljs-keyword">select</span> <span class="hljs-aggregate">count</span>(*) <span class="hljs-keyword">as</span> 数目,<span class="hljs-aggregate">sum</span>(<span class="hljs-string">`总额`</span>) <span class="hljs-keyword">as</span> 盈亏, 
    (<span class="hljs-keyword">select</span> <span class="hljs-aggregate">sum</span>(<span class="hljs-string">`总额`</span>) <span class="hljs-keyword">from</span> <span class="hljs-string">`财政收支`</span> <span class="hljs-keyword">where</span> <span class="hljs-string">`总额`</span> &lt; <span class="hljs-number">0</span> <span class="hljs-keyword">and</span> <span class="hljs-string">`日期`</span> <span class="hljs-keyword">like</span> date_limit) <span class="hljs-keyword">as</span> <span class="hljs-string">'支出'</span>, 
    (<span class="hljs-keyword">select</span> <span class="hljs-aggregate">sum</span>(<span class="hljs-string">`总额`</span>) <span class="hljs-keyword">from</span> <span class="hljs-string">`财政收支`</span> <span class="hljs-keyword">where</span> <span class="hljs-string">`总额`</span> &gt;= <span class="hljs-number">0</span> <span class="hljs-keyword">and</span> <span class="hljs-string">`日期`</span> <span class="hljs-keyword">like</span> date_limit) <span class="hljs-keyword">as</span> <span class="hljs-string">'收入'</span> 
    <span class="hljs-keyword">from</span> <span class="hljs-string">`财政收支`</span> <span class="hljs-keyword">where</span> <span class="hljs-string">`日期`</span> <span class="hljs-keyword">like</span> date_limit;</span>
<span class="hljs-operator"><span class="hljs-keyword">end</span>//</span></code></pre>

<p>JDBC调用方法如下</p>

<pre class="prettyprint"><code class=" hljs avrasm">            //调用过程  -- 统计盈亏、收入、支出
            CallableStatement cStmt = con<span class="hljs-preprocessor">.prepareCall</span>(<span class="hljs-string">"{call payments_statistics(?)}"</span>)<span class="hljs-comment">;</span>
            cStmt<span class="hljs-preprocessor">.setString</span>(<span class="hljs-number">1</span>,<span class="hljs-string">"%"</span>+date+<span class="hljs-string">"%"</span>)<span class="hljs-comment">;</span>
            cStmt<span class="hljs-preprocessor">.execute</span>()<span class="hljs-comment">;</span>
            rs = cStmt<span class="hljs-preprocessor">.getResultSet</span>()<span class="hljs-comment">;</span>
            if(rs<span class="hljs-preprocessor">.next</span>()){
                count = rs<span class="hljs-preprocessor">.getInt</span>(<span class="hljs-number">1</span>)<span class="hljs-comment">;</span>
                all = rs<span class="hljs-preprocessor">.getString</span>(<span class="hljs-number">2</span>)<span class="hljs-comment">;</span>
                allOut = rs<span class="hljs-preprocessor">.getString</span>(<span class="hljs-number">3</span>)<span class="hljs-comment">;</span>
                allIn = rs<span class="hljs-preprocessor">.getString</span>(<span class="hljs-number">4</span>)<span class="hljs-comment">;</span>
            }
            rs<span class="hljs-preprocessor">.close</span>()<span class="hljs-comment">;</span></code></pre></li>
<li><p>建立触发器保证逻辑正确</p>

<pre class="prettyprint"><code class=" hljs sql">
<span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">trigger</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> stock_update;</span>
delimiter //
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">trigger</span> stock_update <span class="hljs-keyword">before</span> <span class="hljs-keyword">update</span> <span class="hljs-keyword">on</span> 药品
<span class="hljs-keyword">for</span> <span class="hljs-keyword">each</span> <span class="hljs-keyword">row</span>
<span class="hljs-keyword">begin</span>
    <span class="hljs-keyword">if</span> new.库存 &lt; <span class="hljs-number">0</span>
    /* MySQL不支持直接使用<span class="hljs-keyword">rollback</span>回滚事务，可以利用<span class="hljs-keyword">delete</span>当前表造成异常使事务回滚 */
    <span class="hljs-keyword">then</span> <span class="hljs-keyword">delete</span> <span class="hljs-keyword">from</span> 药品 <span class="hljs-keyword">where</span> 药品编号=new.药品编号;</span>  
    <span class="hljs-operator"><span class="hljs-keyword">end</span> <span class="hljs-keyword">if</span>;</span>
<span class="hljs-operator"><span class="hljs-keyword">end</span> //
<span class="hljs-keyword">update</span> 药品 <span class="hljs-keyword">set</span> 库存=-<span class="hljs-number">2</span> <span class="hljs-keyword">where</span> 药品编号=<span class="hljs-number">1</span>;</span>

<span class="hljs-operator"><span class="hljs-keyword">drop</span> <span class="hljs-keyword">trigger</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> drugs_insert;</span>
delimiter //
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">trigger</span> drugs_insert <span class="hljs-keyword">before</span> <span class="hljs-keyword">insert</span> <span class="hljs-keyword">on</span> 药品
<span class="hljs-keyword">for</span> <span class="hljs-keyword">each</span> <span class="hljs-keyword">row</span>
<span class="hljs-keyword">begin</span>
    <span class="hljs-keyword">if</span> new.库存 &lt; <span class="hljs-number">0</span> <span class="hljs-keyword">or</span> new.单价 &lt; <span class="hljs-number">0</span> <span class="hljs-keyword">or</span> new.进价 &lt; <span class="hljs-number">0</span> <span class="hljs-keyword">or</span> new.会员折扣 &gt; <span class="hljs-number">1</span> <span class="hljs-keyword">or</span> new.会员折扣 &lt; <span class="hljs-number">0</span>
    <span class="hljs-keyword">then</span> <span class="hljs-keyword">delete</span> <span class="hljs-keyword">from</span> 药品 <span class="hljs-keyword">where</span> 药品编号=new.药品编号;</span>
    <span class="hljs-operator"><span class="hljs-keyword">end</span> <span class="hljs-keyword">if</span>;</span>
<span class="hljs-operator"><span class="hljs-keyword">end</span> //
/*退货数量不应比售出的多*/
<span class="hljs-keyword">drop</span> <span class="hljs-keyword">trigger</span> <span class="hljs-keyword">if</span> <span class="hljs-keyword">exists</span> refunds_insert;</span>
delimiter //
<span class="hljs-operator"><span class="hljs-keyword">create</span> <span class="hljs-keyword">trigger</span> refunds_insert <span class="hljs-keyword">after</span> <span class="hljs-keyword">insert</span> <span class="hljs-keyword">on</span> 退货管理
<span class="hljs-keyword">for</span> <span class="hljs-keyword">each</span> <span class="hljs-keyword">row</span>
<span class="hljs-keyword">begin</span>
    <span class="hljs-keyword">if</span> (<span class="hljs-keyword">select</span> 数量 <span class="hljs-keyword">from</span> sales_records <span class="hljs-keyword">where</span> 销售编号 = new.销售编号) &lt; (<span class="hljs-keyword">select</span> 数量 <span class="hljs-keyword">from</span> reject_records <span class="hljs-keyword">where</span> 退货编号 = new.退货编号)
    <span class="hljs-keyword">then</span> <span class="hljs-keyword">delete</span> <span class="hljs-keyword">from</span> 退货管理 <span class="hljs-keyword">where</span> 退货编号=new.退货编号;</span>
    <span class="hljs-operator"><span class="hljs-keyword">end</span> <span class="hljs-keyword">if</span>;</span>
<span class="hljs-operator"><span class="hljs-keyword">end</span> //</span></code></pre></li>
<li><p>将业务逻辑封装为事务，如销售事务</p></li>
</ul>

<pre class="prettyprint"><code class=" hljs sql">    PreparedStatement ps=null;
    Connection con = DriverManager.getConnection(connectString,"root", "2333");
    ...
            con.setAutoCommit(false);//设置自动提交为false
            ...
            //销售事务 
            //更新库存
            String fmt1="<span class="hljs-operator"><span class="hljs-keyword">update</span> 药品  <span class="hljs-keyword">set</span> <span class="hljs-string">`库存`</span>=<span class="hljs-string">'%d'</span> <span class="hljs-keyword">where</span> <span class="hljs-string">`药品编号`</span>=<span class="hljs-string">'%s'</span><span class="hljs-string">";
            String sql1 = String.format(fmt1,drug_rest-pcount,drug_id); 
            ps = con.prepareStatement(sql1);
            ps.executeUpdate();
            //插入财政收支记录
            String fmt2="</span><span class="hljs-keyword">INSERT</span> <span class="hljs-keyword">INTO</span> <span class="hljs-string">`财政收支`</span> (<span class="hljs-string">`药品编号`</span>,<span class="hljs-string">`员工编号`</span>,<span class="hljs-string">`数量`</span>,<span class="hljs-string">`日期`</span>,<span class="hljs-string">`总额`</span>,<span class="hljs-string">`类型`</span>) <span class="hljs-keyword">VALUES</span> (<span class="hljs-string">'%s'</span>,<span class="hljs-string">'%d'</span>,<span class="hljs-string">'%d'</span>,<span class="hljs-string">'%s'</span>,<span class="hljs-string">'%s'</span>,<span class="hljs-string">'销售'</span>)<span class="hljs-string">";
            String sql2 = String.format(fmt2,drug_id,employee_id,pcount,today,money); 
            ps = con.prepareStatement(sql2);
            ps.executeUpdate(); 
            //获取插入的财政收支编号
            ps = con.prepareStatement("</span><span class="hljs-keyword">select</span> @@<span class="hljs-keyword">identity</span>;</span>");
            rs = ps.executeQuery();
            if(rs.next()){
                financial_id=rs.getInt(1);
            }
            rs.close();
            //插入销售记录
            String fmt3="<span class="hljs-operator"><span class="hljs-keyword">insert</span> <span class="hljs-keyword">into</span> 销售管理(客户编号,收支编号) <span class="hljs-keyword">values</span>(%s,<span class="hljs-string">'%d'</span>)<span class="hljs-string">";
            String sql3 = String.format(fmt3,customer_id,financial_id); 
            ps = con.prepareStatement(sql3);
            ps.executeUpdate();
            //提交事务
            con.commit();
      }catch(Exception e){
         try {
             con.rollback();
         } catch (Exception e1) {
             e1.printStackTrace();
         }</span></span></code></pre>

<h2 id="界面效果">界面效果</h2>

<p>登陆 <br>
<img src="http://img.blog.csdn.net/20170302222025938?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
主页 <br>
<img src="http://img.blog.csdn.net/20170302222045653?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
仓库 <br>
<img src="http://img.blog.csdn.net/20170302222147373?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
点击新增进行药品入库 <br>
<img src="http://img.blog.csdn.net/20170302222211092?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
入库/销售/退货记录 <br>
<img src="http://img.blog.csdn.net/20170302222234936?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
员工可查看/增加客户，供应商 <br>
<img src="http://img.blog.csdn.net/20170302222635362?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
经理可增删员工、客户、供应商 <br>
<img src="http://img.blog.csdn.net/20170302223443912?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
销售药品 <br>
<img src="http://img.blog.csdn.net/20170302223031520?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
<img src="http://img.blog.csdn.net/20170302223048129?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
退货 <br>
<img src="http://img.blog.csdn.net/20170302223119239?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""> <br>
财务统计 <br>
<img src="http://img.blog.csdn.net/20170302223256755?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3lj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="这里写图片描述" title=""></p>

