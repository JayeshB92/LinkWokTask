<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Email</title>

        <%
            String columns = request.getParameter("column");
            String range = request.getParameter("range");
        %>

        <script type="text/javascript">
            var selectedEmails;
            var columns = "<%=columns%>";
            var range = "<%=range%>";
            var selectedColumn = columns.split(',');
            var columnData = range.split(':');
            columnData = columnData.slice(0, -1);
            var selectedColumnEntries = [];
            function appendEmailAddresses() {
                for (var j = 0; j < columnData.length; j++) {
                    var column = columnData[j];
                    var columnEntries = column.split(',');
                    for(var i=0; i<selectedColumn.length; i++) {
                        if(columnEntries.indexOf(selectedColumn[i]) > -1) {
                            columnEntries = columnEntries.slice(1, columnEntries.length);
                            selectedColumnEntries.push(columnEntries.join(','));
                        }
                    }
                }
                document.getElementById('to').value = selectedColumnEntries.join(',');
            }
        </script>
    </head>
    <body onload="appendEmailAddresses();">
        <h3>Email Form</h3>
        <form action="#" method="post">
            To: <textarea id="to" readonly="true" cols="40" rows="3" name="to"></textarea><br/>
            Subject: <input type="text" id="subject" name="subject"/><br/>
            Message: <textarea cols="40" rows="3" name="messsge"></textarea><br/>
            <button type="submit">Send Mails</button>
        </form>
    </body>
</html>
