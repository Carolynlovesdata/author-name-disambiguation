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
    public partial class MainPlato : Form
    {
        public MainPlato()
        {
            InitializeComponent();
            comboBox1.Items.Add("jg_sim");
            comboBox1.Items.Add("new_all");
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (comboBox1.SelectedItem.ToString() == "jg_sim")
            {
                jg_sim f2 = new jg_sim();

                //f2.MdiParent = this;

                f2.Show();
            }
            else if(comboBox1.SelectedItem.ToString() == "new_all")
            {

            }
        }

        
    }
}
