# Deploy Student Ranges
1. Get a class roster and put first name and last name into a CSV.
    see [students.csv](./students.csv)

    Example: `john,basilone`

2. Generate a list of usernames with [userName.sh](./userName.sh)

    Username format is `FFLL-XXX-M`

    Example: John Basilone would be `JOBA-022-M`.

    Copy the output from this script
    ```sh
    # The script will prompt you for the class number
    chmod u+x userName.sh
    ./userName.sh students.csv
    ```

3. Navigate to `CVTE > Aria Automation: Cyber School > Service Broker > Catalog > Deploy CCTC Security - Challenge`

4. Fill out the required fields and paste the generated user name list (ensure to leave `student_name` at the top of the list)

    Classname ex: `CCTC-F-ME-022`

    F for funcitonal, ME for Marine Enlisted

5. Include a couple extra student stacks for backups and demos in the student list (userName.sh will do this automatically)
    ```
    XTRA1-022-M
    XTRA2-022-M
    XTRA3-022-M
    XTRA4-022-M
    XTRA5-022-M
    ```
6. Student will deploy their opstations
    Students will navigate to `cvte > aria automation: cyber school > service broker > catalog > CCTC-Security-Opstations` and deploy their own opstations.

> [!WARNING]
> If OS opstations are still present, have students remove them.

7. Obtain the students Jump boxes IP and pass

    Students will run:
    ```bash
    # Create port forward to the webex
    ssh demo1@10.50.0.161 -L 8888:10.208.50.61:80

    # browse to this site
    http://127.0.0.1:8888/classinfo.html
    ```
    Student will enter their username `FFLL-XXX-M`

    This will show their jump info and remove it from db, make sure they write it down as they will not be able to access it again.

8. Provide students with CTFd server IP which they will access from their opstations.

    They will login with their `FFL-022-M` Username and thier jumpbox password they pulled from classinfo.html.

> [!NOTE]
> You can find the IP of the CTFd server from the `<CLASS_TITLE>-CCTC-Security-Challenge-Instructor` deployment
