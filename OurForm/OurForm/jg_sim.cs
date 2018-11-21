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
    public partial class jg_sim : Form
    {
        
        public jg_sim()
        {
            InitializeComponent();
            string connstr;
            string commstr;
            /////string commstr;
            connstr = ConfigurationSettings.AppSettings["connstr"].ToString();
            MySqlConnection conn = new MySqlConnection(connstr);
            
                commstr = "select * from jg_sim";
            
            MySqlDataAdapter da = new MySqlDataAdapter(commstr, connstr);
            //da.SelectCommand.Parameters.AddWithValue("@username", username);
            DataSet ds = new DataSet();
            da.Fill(ds);
            this.dataGridView1.DataSource = ds.Tables[0];//数据源  
            this.dataGridView1.AutoGenerateColumns = true;//不自动  
            //conn.Close();//关闭数据库连接  
        }
        
        private void button1_Click(object sender, EventArgs e)
        {
            search s1 = new search();
            s1.Show();
        }
    }
}
