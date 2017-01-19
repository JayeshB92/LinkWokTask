<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <script type="text/javascript">
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
                var authorizeDiv = document.getElementById('authorize-div');
                if (authResult && !authResult.error) {
                    authorizeDiv.style.display = 'none';
                    loadDriveApi();
                } else {
                    authorizeDiv.style.display = 'inline';
                }
            }
            function handleAuthClick(event) {
                gapi.auth.authorize(
                        {client_id: CLIENT_ID, scope: SCOPES, immediate: false},
                        handleAuthResult);
                return false;
            }

            function loadDriveApi() {
                gapi.client.load('drive', 'v3', listFiles);
            }

            function listFiles() {
                var request = gapi.client.drive.files.list({
                    'q': "mimeType='application/vnd.google-apps.spreadsheet' or mimeType='application/vnd.ms-excel' or mimeType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'",
                    'fields': "nextPageToken, files(id, name)"
                });

                request.execute(function (resp) {
                    var files = resp.files;
                    if (files && files.length > 0) {
                        for (var i = 0; i < files.length; i++) {
                            var file = files[i];
                            appendFile(file.id, file.name);
                        }
                    } else {
                        appendPre('No files found.');
                    }
                });
            }

            function appendPre(message) {
                var pre = document.getElementById('output');
                var textContent = document.createTextNode(message + '\n');
                pre.appendChild(textContent);
            }

            function appendFile(id, name) {
                var files = document.getElementById('files');
                var option = document.createElement("option");
                option.value = id;
                option.text = name;
                files.add(option);
            }


        </script>
        <script src="https://apis.google.com/js/client.js?onload=checkAuth">
        </script>
    </head>
    <body>
        <div id="authorize-div" style="display: none">
            <h2>Connect With Google</h2><br/>
            <span>Authorize access to Google Sheets API</span><br/>
            <!--Button for the user to click to initiate auth sequence -->
            <button id="authorize-button" onclick="handleAuthClick(event)">
                Connect With Google
            </button><br/><br/>
        </div>
        <h2>Spreadsheets From Your Google Drive</h2>
        <form action="filecontent.jsp" method="post">
            <table border="0">
                <tr>
                    <td>
                        Files:
                    </td>
                    <td>
                         <select id="files" name="file" required="true">
                            <option value="">Select File</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <button type="submit">Submit</button>
                    </td>
                </tr>
            </table>
        </form>
        <pre id="output"></pre>
    </body>
</html>