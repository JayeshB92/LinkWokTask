<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Spreadsheet Content</title>

        <%
            String spreadsheetId = request.getParameter("file");
        %>

        <script type="text/javascript">
            var range;
            var columnData = '';
            var CLIENT_ID = '207977071828-0bb5kduca1co0c0o89a6dhk0o298n9v7.apps.googleusercontent.com';
            var SCOPES = ["https://www.googleapis.com/auth/spreadsheets.readonly", "https://www.googleapis.com/auth/drive.readonly"];
            function checkAuth() {
                gapi.auth.authorize(
                        {
                            'client_id': CLIENT_ID,
                            'scope': SCOPES.join(' '),
                            'immediate': true
                        }, handleAuthResult);
            }
            function handleAuthResult(authResult) {
                if (authResult && !authResult.error) {
                    loadSheetsApi();
                }
            }

            function loadSheetsApi() {
                var discoveryUrl = 'https://sheets.googleapis.com/$discovery/rest?version=v4';
                gapi.client.load(discoveryUrl).then(listMajors);
            }

            function listMajors() {
                gapi.client.sheets.spreadsheets.values.get({
                    spreadsheetId: '<%=spreadsheetId%>',
                    range: 'A1:ZZZ',
                    majorDimension: 'COLUMNS'
                }).then(function (response) {
                    range = response.result;
//                    alert(range.values);
                    var flag = true;
                    if (range.values.length > 0) {
                        for (i = 0; i < range.values.length; i++) {
                            var column = range.values[i];
                            columnData = columnData.concat(column.join(','), ":");
                            if (column[0].toString().toLowerCase().includes("email")) {
                                flag = false;
                                appendColumns(column[0].toString());
                            }
                        }
                        if (flag) {
                            appendPre('Email Column not found.');
                            window.setTimeout(function () {
                                window.location.href = "/LinkWokDemo/index.jsp";
                            }, 5000);
                        }
                        appendHiddenFormField();
                    } else {
                        appendPre('No data found.');
                    }
                }, function (response) {
                    appendPre('Error: ' + response.result.error.message);
                });
            }

            function appendColumns(value) {
                var container = document.getElementById('columns');

                var checkbox = document.createElement('input');
                checkbox.type = "checkbox";
                checkbox.name = "email-column";
                checkbox.value = value;
                checkbox.id = value;

                var label = document.createElement('label');
                label.htmlFor = value;
                label.appendChild(document.createTextNode(value));

                container.appendChild(checkbox);
                container.appendChild(label);
            }

            function appendPre(message) {
                var pre = document.getElementById('output');
                var textContent = document.createTextNode(message + '\n');
                pre.appendChild(textContent);
            }

            function appendHiddenFormField() {
                var form = document.getElementById('fileContentForm');

                var hidden = document.createElement('input');
                hidden.type = "hidden";
                hidden.name = "range";
                hidden.value = columnData;

                form.appendChild(hidden);
            }

            function fetchEmailColumns() {
                var arr = [];
                var checkboxes = document.getElementsByName("email-column");
                // loop over them all
                for (var i = 0; i < checkboxes.length; i++) {
                    // And stick the checked ones onto an array...
                    if (checkboxes[i].checked) {
                        arr.push(checkboxes[i].value);
                    }
                }

                document.getElementById('hidden-column').setAttribute("value", arr.join(','))

                document.getElementById('fileContentForm').submit();
            }
        </script>
        <script id="checkAuthScript" src="https://apis.google.com/js/client.js?onload=checkAuth">
        </script>
    </head>
    <body>
        <form id="fileContentForm" action="email.jsp" method="post">
            Columns: <span id="columns"></span><br/>
            <button type="button" onclick="fetchEmailColumns();">Submit</button>
            <input type="hidden" name="column" id="hidden-column"/>
        </form>
        <pre id="output"></pre>
    </body>
</html>
