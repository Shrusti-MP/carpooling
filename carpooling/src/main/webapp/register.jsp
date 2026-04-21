<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />

<div class="row justify-content-center">
    <div class="col-md-5">
        <div class="card shadow-sm border-0 mt-5">
            <div class="card-body p-4">
                <h3 class="text-center mb-4">Create an Account</h3>
                
                <% if(request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
                <% } %>
                
                <form action="RegisterServlet" method="POST">
                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email address</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-success btn-block">Register</button>
                    </div>
                </form>
                <div class="text-center mt-3">
                    <p>Already have an account? <a href="login.jsp">Login here</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
