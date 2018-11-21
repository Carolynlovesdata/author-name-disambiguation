using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MySql.Data.MySqlClient;
using System.Configuration;
namespace OurForm
{
    public partial class Form1 : Form
    {
        /*private DataSet dsall;
        private static String mysqlcon = "database=test;Password=maobuyi;User ID=maoyue;server=192.168.1.102";//Data Source=MySQL;;charset=utf8";
        private MySqlConnection conn;
        private MySqlDataAdapter mDataAdapter;*/
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string username = textBox1.Text;
            string password = textBox2.Text;

            DataSet ds = dataoper.user_login(username);
            if(username==ds.Tables[0].Rows[0]["username"].ToString())
            {
                if(password== ds.Tables[0].Rows[0]["password"].ToString())
                {
                    this.DialogResult = DialogResult.OK;
                    this.Close();
                }
                else
                {
                    MessageBox.Show("密码错误！");
                }
            }
            else
            {
                MessageBox.Show("用户名错误！");
            }
            
        }
    }
}
