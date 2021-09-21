use Ham::APRS::IS;
use Ham::APRS::FAP qw(parseaprs);
use DBI;
use Data::Dumper qw(Dumper);

my ($db_user, $db_name, $db_pass) = ('aprs2sql', 'aprs', 'password');
my $dbh = DBI->connect("DBI:mysql:database=$db_name", $db_user, $db_pass);
my $query_test = $dbh->prepare('SELECT * FROM packet');
$query_test->execute() or die $query_test->err_str;

my $aprsServer = 'aprs.hc.r1.ampr.org:14580';
my $aprsLoginCallsign = 'N0CALL';
my $aprsAppid = 'aprs2sql 0.1';

#my $aprsFilter = 'p/da/db/dc/dd/df/dg/dh/di/dj/dk/dl/dm/dn/do/dp/dq/dr -u/APLWS*/APRARX/APZDMR/DRMT* -b DRMT*';
my $aprsFilter = 'b/dj1an-1 d/dj1an-1';

my $is = new Ham::APRS::IS($aprsServer, $aprsLoginCallsign, 'appid' => $aprsAppid, 'filter' => $aprsFilter);

sub connectAPRSIS{
  print "Connecting to APRS-IS...\n"; 
  $is->connect('retryuntil' => 60) || die "Failed to connect: $is->{error}";
  print "APRS-IS Connected.\n"; 
}
 
connectAPRSIS();

#for (my $i = 0; $i < 2; $i += 1) {
while(1){

    if (! $is->connected()){
      print "APRS Disconnected\n"; 
      connectAPRSIS();
    }

    my $l = $is->getline_noncomment();
    #my $l = 'DJ1AN-1>APZAVR-1,qAR,DB0HFT-L4:T#284,148,374,118,401,380,00000000';
    next if (!defined $l);
    print "\n--- new packet ---\n$l\n";
     
    my %packetdata;
    my $retval = parseaprs($l, \%packetdata);
     
    if ($retval == 1) {
        #while (my ($key, $value) = each(%packetdata)) {
        #    print "$key: $value\n";
        #}
        
        if ($packetdata{'type'} eq "telemetry") {
          #print Dumper \%packetdata;
          $sth = $dbh->prepare("insert into telemetry ( callsign, seq, ch0raw, ch1raw, ch2raw, ch3raw, ch4raw, bits, raw) values (?,?,?,?,?,?,?,?,?)");
          $sth->execute(
                        $packetdata{'srccallsign'}, 
                        $packetdata{'telemetry'}{seq}, 
                        $packetdata{'telemetry'}{vals}[0], 
                        $packetdata{'telemetry'}{vals}[1], 
                        $packetdata{'telemetry'}{vals}[2], 
                        $packetdata{'telemetry'}{vals}[3], 
                        $packetdata{'telemetry'}{vals}[4], 
                        $packetdata{'telemetry'}{bits},
                        $packetdata{'origpacket'});
          #$dbh->commit;
        }
        #print Dumper \%packetdata;
        my $substr = 'DJ1AN-1*';
        my $digipeated = 0; 
        
        if (index($packetdata{'header'}, $substr) != -1) {
          #print "$str contains $substr\n";
          $digipeated = 1;
        } 
        #print $packetdata{'digipeaters'}{0};
        # prepare sql insert
        $sth = $dbh->prepare("insert into packet ( callsign, lat, lon, dest, comment, raw, type, symboltable, symbolcode, digipeated) values (?,?,?,?,?,?,?,?,?,?)");
        $sth->execute(
                      $packetdata{'srccallsign'}, 
                      $packetdata{'latitude'}, 
                      $packetdata{'longitude'}, 
                      $packetdata{'dstcallsign'}, 
                      $packetdata{'comment'}, 
                      $packetdata{'origpacket'},
                      $packetdata{'type'},
                      $packetdata{'symboltable'},
                      $packetdata{'symbolcode'},
                      $digipeated);
        #$dbh->commit;
        
    } else {
        warn "Parsing failed: $packetdata{resultmsg} ($packetdata{resultcode})\n";
    }
}
 
$is->disconnect() || die "Failed to disconnect: $is->{error}";
$dbh->disconnect;
