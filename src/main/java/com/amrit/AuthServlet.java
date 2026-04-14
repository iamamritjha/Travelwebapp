package com.amrit;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import org.bson.Document;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

protected void doGet(HttpServletRequest request,HttpServletResponse response)
throws ServletException,IOException{

String action=request.getParameter("action");

if(action==null || action.equals("home")){
request.getRequestDispatcher("WEB-INF/home.jsp").forward(request,response); }

else if(action.equals("signup")){
request.getRequestDispatcher("WEB-INF/signup.jsp").forward(request,response); }

else if(action.equals("signin")){
request.getRequestDispatcher("WEB-INF/signin.jsp").forward(request,response); }

else if(action.equals("logout")){
request.getSession().invalidate();
response.sendRedirect("auth?action=home"); }
}

protected void doPost(HttpServletRequest request,HttpServletResponse response)
throws ServletException,IOException{

String action=request.getParameter("action");

// MongoDB collection
MongoCollection<Document> collection = MongoUtil
.getDatabase()
.getCollection("admindetail");


// ================= REGISTER =================
if(action.equals("register")){

String fullname = request.getParameter("fullname");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String userid = request.getParameter("userid");
String password = request.getParameter("password");

// 🔒 Duplicate user check
Document existingUser = collection.find(
Filters.eq("userid", userid)
).first();

if(existingUser != null){
request.setAttribute("errorMessage", "User already exists");
request.getRequestDispatcher("WEB-INF/error.jsp").forward(request,response);
return;
}

// Insert into MongoDB
Document doc = new Document("fullname", fullname)
.append("email", email)
.append("phone", phone)
.append("userid", userid)
.append("password", password);

collection.insertOne(doc);

response.sendRedirect("auth?action=signin");
}


// ================= LOGIN =================
else if(action.equals("login")){

String userid=request.getParameter("userid");
String password=request.getParameter("password");

// Find user in MongoDB
Document user=collection.find(
Filters.and(
Filters.eq("userid",userid),
Filters.eq("password",password)
)
).first();

if(user!=null){

request.getSession().setAttribute("user",userid);
request.getSession().setAttribute("displayName", user.getString("fullname"));
response.sendRedirect("booking?action=dashboard");

}else{

request.setAttribute("errorMessage","Invalid Login Credentials");
request.getRequestDispatcher("WEB-INF/error.jsp").forward(request,response);

}
}
}
}