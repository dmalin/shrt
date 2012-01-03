Shrt: The Lazymans tool to make short links
==============================================

Description
-----------
How many times have you had a GIGANTIC URL and then gone to bitly or another such service and gotten a shortend link. At first its not a big deal. 
But working as a developer things like this start to occrr ALOT. Its annoying after the 500th time.
Their api is extremely aesy to use.... just wish FAILED AUTH requests were NOT returned as 200's beyond a buried response code of their own 
on the returned body. HTTP already supports the ability to set a response code ... thats the place for it. 200 not authenticated with no body != 200


How To Use/Documentation
-------------

Using The Binary (shrt)
     
    
    ./shrt http://realllyrealllyrealllyrealllylongdomain.com
    
    Bitly URL Shortner 0.45
    ------------------------------------------------------------
    Copyright Puper Heavy Industries 2012
    
    
    URL: http://realllyrealllyrealllyrealllylongdomain.com => SHRT: http://bit.ly/z9rvZg
    The Shortened URL Has been pushed into your clipboard too.
     


Also See Code. It could not be be Simpler


Next Steps
---------
Right now the binary is just in the bin and also there is no gem et. Intended to get spec coverage up to 100$% before either is of the previous items are done,
Also right now only support for a single domain exists , that will change too.


License
-------

See LICENSE file.