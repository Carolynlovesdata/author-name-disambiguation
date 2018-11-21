using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Configuration;
using System.Configuration.Assemblies;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;

namespace OurForm
{
    class dataoper
    {
        public static DataSet user_login(string username)
        {
            string connstr;
            string commstr;
            connstr = ConfigurationSettings.AppSettings["connstr"].ToString();
            MySqlConnection conn = new MySqlConnection(connstr);
            commstr = "select * from userinfo";
            MySqlDataAdapter da = new MySqlDataAdapter(commstr, connstr);
            da.SelectCommand.Parameters.AddWithValue("@username", username);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }
    }
}
