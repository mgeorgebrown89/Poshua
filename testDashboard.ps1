$Dashboard = New-UDDashboard -Title "Hello, World!" -Content {
    New-UDHeading -Text "Hello, World!" -Size 1
}
Start-UDDashboard -Dashboard $Dashboard -Port 443