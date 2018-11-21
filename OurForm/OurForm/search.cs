using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;
using MySql.Data.MySqlClient;

namespace OurForm
{
    public partial class search : Form
    {
        TableLayoutPanel table = new TableLayoutPanel();

        public search()
        {
            InitializeComponent();
            panel1.Location = new Point((this.Width - panel1.Width) / 2, (this.Height - panel1.Height) / 2);
            
            table_init();

        }
       
        private void table_init()
        {
            
            groupBox1.Size = new Size(410, h);
            table.Dock = DockStyle.Top;
            groupBox1.Controls.Add(table);
            // table.RowCount++;
            table.ColumnCount = 6;
           
            table.Height = table.RowCount * 40;
            

            table.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.AutoSize));
            table.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.AutoSize));
            table.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.AutoSize));
            table.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.AutoSize));
            table.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.AutoSize));
            table.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.AutoSize));
            for (int ii = 0; ii < table.RowCount; ii++)
            {
                table.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 40));
            }
            groupBox1.Height = table.RowCount * 40 + 10;
        }
        public int watch_num = 0;
        public int h = 72;
        public int loc = 30;

        //动态添加
        private void button1_Click(object sender, EventArgs e)
        {
            watch_num++;
            // 动态添加一行
            table.RowCount++;
            //设置高度
            table.Height = table.RowCount * 40 + 10;

            // 行高
            table.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 40));
            // 设置cell样式，
            table.CellBorderStyle = TableLayoutPanelCellBorderStyle.Single;

            int i = table.RowCount - 1;
            // 添加控件
            ComboBox new_cond = new ComboBox();
            new_cond.Size = new Size(140, 24);
            new_cond.Font = new Font("宋体", 12);
            new_cond.Name = "newcond_" + watch_num.ToString();
            new_cond.Items.Add("机构作者相似度");
            new_cond.Items.Add("机构名称相似度");
            new_cond.Items.Add("合作机构相似度");
            new_cond.Items.Add("合作者相似度");
            new_cond.Items.Add("题名相似度");
            new_cond.Items.Add("关键词相似度");
            new_cond.SelectedIndex = 0;
            new_cond.Anchor = AnchorStyles.Left;
            new_cond.DropDownStyle = ComboBoxStyle.DropDownList;
    
            table.Controls.Add(new_cond, 0, i);

            ComboBox range1 = new ComboBox();
            range1.Size = new Size(50, 24);
            range1.Font = new Font("宋体", 12);
            range1.Name = "range1_" + watch_num.ToString();
            range1.Items.Add(">");
            range1.Items.Add(">=");
            range1.Items.Add("=");
    /////        range1.Items.Add("<");
  /////          range1.Items.Add("<=");
            range1.SelectedIndex = 0;
            range1.Anchor = AnchorStyles.Right;
            range1.DropDownStyle = ComboBoxStyle.DropDownList;
 
            table.Controls.Add(range1, 1, i);

            TextBox sim_txt1 = new TextBox();
            sim_txt1.Width = 40;
            sim_txt1.Text = "";
            sim_txt1.Anchor = AnchorStyles.Left;
            sim_txt1.TextAlign = HorizontalAlignment.Center;
            sim_txt1.Name = "simtxt1_" + watch_num.ToString();
            table.Controls.Add(sim_txt1, 2, i);

            ComboBox range2 = new ComboBox();
            range2.Size = new Size(50, 24);
            range2.Font = new Font("宋体", 12);
            range2.Name = "range2_" + watch_num.ToString();
 /////           range2.Items.Add(">");
    /////        range2.Items.Add(">=");
    /////        range2.Items.Add("=");
            range2.Items.Add("<");
            range2.Items.Add("<=");
            range2.SelectedIndex = 0;
            range2.Anchor = AnchorStyles.Right;
            range2.DropDownStyle = ComboBoxStyle.DropDownList;

            table.Controls.Add(range2, 3, i);

            TextBox sim_txt2 = new TextBox();
            sim_txt2.Text = "";
            sim_txt2.Width = 40;
            sim_txt2.Anchor = AnchorStyles.Left;
            sim_txt2.TextAlign = HorizontalAlignment.Center;
            sim_txt2.Name = "simtxt2_" + watch_num.ToString();

            table.Controls.Add(sim_txt2, 4, i);

            ComboBox chosen_box = new ComboBox();
            chosen_box.Width = 45 ;
            chosen_box.Items.Add("AND");
            chosen_box.Items.Add("OR");
            chosen_box.Name = "chosenbox_" + watch_num.ToString();
            chosen_box.SelectedIndex = 0;
            chosen_box.Anchor = AnchorStyles.Left;
            chosen_box.DropDownStyle = ComboBoxStyle.DropDownList;
            table.Controls.Add(chosen_box, 5, i);

            groupBox1.Height = table.Height + 10;

            button2.Top = 70 + groupBox1.Height;
            button3.Top = 70 + groupBox1.Height;
            button5.Top = 70 + groupBox1.Height;
        }


        //清除查询
        private void button3_Click(object sender, EventArgs e)
        {
            watch_num = 0;
            table.Controls.Clear();
            groupBox1.Controls.Clear();

            foreach (Control i in panel1.Controls)
            {
                if (i is TextBox)
                {
                    i.Text = "";

                }
            }
            h = 72;
            groupBox1.Size = new Size(410, h);
            table.RowCount = 0;

            this.button2.Top = 60 + groupBox1.Height;
            this.button3.Top = 60 + groupBox1.Height;
            this.button5.Top = 60 + groupBox1.Height;
            table_init();
        }

        //清除内容
        private void button5_Click(object sender, EventArgs e)
        {
            foreach (Control i in panel1.Controls)
            {
                if (i is TextBox)
                {
                    i.Text = "";

                }
            }
            foreach(Control j in table.Controls)
            {
                if(j is TextBox)
                {
                    j.Text = "";
                }
                
            }
            
        }

        //查询
        
        private void button2_Click(object sender, EventArgs e)
        {

            string connstr;
            string commstr;
            connstr = ConfigurationSettings.AppSettings["connstr"].ToString();
            MySqlConnection conn = new MySqlConnection(connstr);
            conn.Open();


            string zz_name;
            string zz_jg;
            zz_name = zz_txt.Text.ToString();
            zz_jg = jg_txt.Text.ToString();
            ComboBox newcond;
            ComboBox range11;
            string simtxt1;
            ComboBox range22;
            string simtxt2;
            ComboBox chosenbox;
            commstr = "";
            string temp_comm = "";
            MessageBox.Show(watch_num.ToString());
            int flag;
            flag = 0;
            temp_comm = "";
            if (watch_num > 0)
            {
                if (zz_name != "" || zz_jg != "")
                {
              ///      flag = 1;
                    if (zz_name != "")
                    {
                        if (zz_jg == "")
                        {
                            temp_comm = temp_comm + "zzmc='" + zz_name + "'";
                        }
                        else
                        {
                            temp_comm = temp_comm + "zzmc='" + zz_name + "' and (jg1 like '%" + zz_jg + "%' or jg2 like '%" + zz_jg + "%')";
                        }
                    }
                    else if (zz_name == "")
                    {
                        temp_comm = temp_comm + "(jg1 like '%" + zz_jg + "%' or jg2 like '%" + zz_jg + "%')";
                    }
                    temp_comm = temp_comm + " and ((";
                }
                else
                {
                    temp_comm = temp_comm + "((";
                }

                for (int i = 0; i < watch_num; i++)
                {
            
                    newcond = (ComboBox)table.Controls.Find("newcond_" + (i+1).ToString(), true)[0];
                    range11 = (ComboBox)table.Controls.Find("range1_" + (i+1).ToString(), true)[0];
                    simtxt1 = ((TextBox)table.Controls.Find("simtxt1_" + (i+1).ToString(), true)[0]).Text.ToString();
                    range22 = (ComboBox)table.Controls.Find("range2_" + (i+1).ToString(), true)[0];
                    simtxt2 = ((TextBox)table.Controls.Find("simtxt2_" + (i+1).ToString(), true)[0]).Text.ToString();
                    chosenbox = (ComboBox)table.Controls.Find("chosenbox_" + (i+1).ToString(), true)[0];

                    if (simtxt1!=""||simtxt2!="")
                    {
                        flag = 1;

                        if(newcond.SelectedIndex==0)
                        {
                            temp_comm = temp_comm + "sim1 ";
                            if (simtxt1 != "")
                            {
                                if (simtxt2 == "")
                                {
                                    temp_comm = temp_comm + range11.SelectedItem.ToString() + " " + Double.Parse(simtxt1);
                                }
                                else if(simtxt2!="")
                                {
                                    temp_comm = temp_comm + range11.SelectedItem.ToString() + " " + Double.Parse(simtxt1)+" and sim1 "+range22.SelectedItem.ToString()+" "+Double.Parse(simtxt2);
                                }
                            }
                            else if(simtxt1=="")
                            {
                                temp_comm = temp_comm + range22.SelectedItem.ToString() + " " + Double.Parse(simtxt2);
                            }
                        }
                        else if(newcond.SelectedIndex==1)
                        {
                            temp_comm = temp_comm + "sim2 ";
                            if (simtxt1 != "")
                            {
                                if (simtxt2 == "")
                                {
                                    temp_comm = temp_comm + range11.SelectedItem.ToString() + " " + Double.Parse(simtxt1);
                                }
                                else if (simtxt2 != "")
                                {
                                    temp_comm = temp_comm + range11.SelectedItem.ToString() + " " + Double.Parse(simtxt1) + " and sim2 " + range22.SelectedItem.ToString() + " " + Double.Parse(simtxt2);
                                }
                            }
                            else if (simtxt1 == "")
                            {
                                temp_comm = temp_comm + range22.SelectedItem.ToString() + " " + Double.Parse(simtxt2);
                            }
                        }

                        if (i < (watch_num - 1))
                        {
                            if (chosenbox.SelectedIndex == 0)
                            {
                                temp_comm = temp_comm + ") and (";
                            }
                            else if (chosenbox.SelectedIndex == 1)
                            {
                                temp_comm = temp_comm + ") or (";
                            }
                        }
                        else if(i==(watch_num-1))
                        {
                            temp_comm = temp_comm + "))";
                        }
                      
                    }
                    else
                    {
                        continue;
                    }



                    if (flag==1)
                    {
                        commstr = "select * from jg_sim where " + temp_comm;
                    }

                }
            }
            else if(watch_num==0)
            {
                
                if (zz_name != "")
                {
                    flag = 1;
                    if (zz_jg != "")
                    {
                        commstr = "select * from jg_sim where zzmc='" + zz_name + "'" + " and (jg1 like '%" + zz_jg + "%' or jg2 like '%"+zz_jg+"%')";
                    }
                    else
                    {
                        commstr = "select * from jg_sim where zzmc='" + zz_name + "'";
                    }
                }
                else
                {
                    if (zz_jg != "")
                    {
                        flag = 1;
                        commstr = "select * from jg_sim where jg1 like'%" + zz_jg + "%' or jg2 like '%"+zz_jg+"%'";
                    }
                    else
                    {
                        MessageBox.Show("请输入查询条件！");
                    }
                }
                
                //commstr = "select * from jg_sim where zzmc like '%" + zz_name + "%' and jgmc like '%" + zz_jg + "%'";
            }

            if (watch_num > 0 && flag == 0)
            {
                MessageBox.Show("请输入查询条件！");
            }

            if (flag == 1)
            {
                MessageBox.Show(commstr);



                MySqlDataAdapter da = new MySqlDataAdapter(commstr, connstr);
                DataSet ds = new DataSet();
                da.Fill(ds, "jg_sim");

                dataGridView1.DataSource = ds;
                dataGridView1.DataMember = ds.Tables[0].TableName;
            }
            conn.Close();
        }
    }
}


  
