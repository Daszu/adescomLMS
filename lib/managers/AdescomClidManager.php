<?php

/**
 * AdescomClidManager
 *
 * @author ADESCOM <info@adescom.pl>
 */
class AdescomClidManager
{
    /**
     * Returns clients CLIDs
     * 
     * @param int $clientID Client id
     * @param AdescomSoapClient $connection Connection
     * @return array CLIDs
     */
    public function getCLIDsForClient($clientID, AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }

        $response = $connection->getCLIDsForClientByExternalID($clientID);

        $results = array();

        if (is_array($response->items)) {
            foreach ($response->items as $clid) {
                $results[] = self::getCLIDArray($clid);
            }
        }

        return $results;
    }
    
    /**
     * Modifies CLID
     * 
     * @param int $callerID Client id
     * @param string $clid CLID
     * @param AdescomSoapClient $connection Connection
     */
    public function modifyCLID($callerID, $clid, AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }
        
        $old_data = $connection->getCLID($callerID);
        
        $data = self::prepareCLIDData($clid);

        if ($old_data->callerID == $callerID) {
            $webservices_type = ConfigHelper::getConfig('adescom.webservices_type');
            if ($webservices_type === AdescomConnection::PLATFORM_WEBSERVICE) {
                unset($data->callerID);
                unset($data->number);
            }
        }

        if ($old_data->macAddress == $data->macAddress) {
            unset($data->macAddress);
        }

        if ($old_data->serialNumber == $data->serialNumber) {
            unset($data->serialNumber);
        }
        
        $connection->modifyCLID($callerID, $data);
    }

    /**
     * Returns CLID informations
     * 
     * @param string $callerID CLID
     * @param AdescomSoapClient $connection Connection
     * @return array CLID
     */
    public function getCLID($callerID, AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }

        $clid = $connection->getCLID($callerID);

        if ($clid === null) {
            return null;
        }

        return self::getCLIDArray($clid);
    }
    
    /**
     * Adds CLID
     * 
     * @param int $clientID Client id
     * @param array $clid CLID
     * @param AdescomSoapClient $connection Connection
     */
    public function addCLID($clientID, array $clid, AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }

        $data = self::prepareCLIDData($clid);

        $connection->addCLIDByExternalID($clientID, $data);

        if ($data->active == 1) {
            $connection->activateCLID($data->callerID);
        }
    }

    /**
     * Adds CLIDs
     * 
     * @param array $clids CLIDs
     * @param AdescomSoapClient $connection Connection
     */
    public function addCLIDs(array $clids, AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }

        $request = new stdClass();

        foreach ($clids as $clid) {
            $request->items[] = self::prepareCLIDData($clid);
        }

        $request->count = count($request->items);

        $connection->addCLIDsByExternalID($request);
    }
    
    /**
     * Returns CLIDs
     * 
     * @param array $clids CLIDs
     * @param AdescomSoapClient $connection Connection
     * @return array CLIDs
     */
    public function getCLIDs(array $clids, AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }

        $response = $connection->getCLIDs($clids);
        
        $results = array();

        $webservices_type = ConfigHelper::getConfig('adescom.webservices_type');
        if ($webservices_type === AdescomConnection::PLATFORM_WEBSERVICE) {
            if (is_array($response->clids)) {
                foreach ($response->clids as $clid) {
                    $results[] = self::getCLIDArray($clid);
                }
            }
        } else {
            if (is_array($response->items)) {
                foreach ($response->items as $clid) {
                    $results[] = self::getCLIDArray($clid);
                }
            }
        }

        return $results;
    }
    
    /**
     * Deletes CLID
     * 
     * @param type $callerID CLID
     * @param AdescomSoapClient $connection Connection
     */
    public function deleteCLID($callerID, AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }
        $connection->deleteCLID($callerID);
    }
    
    /**
     * generates CLID license
     * 
     * @param AdescomSoapClient $connection Connection
     * @return string License
     */
    public function generateCLIDLicense(AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }
        return $connection->generateCLIDLicense();
    }
    
    /**
     * Returns CLID status
     * 
     * @param string $callerid CLID
     * @param AdescomSoapClient $connection Connection
     * @return stdClass Status
     */
    public function getCLIDStatus($callerid, AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }
        $items = $connection->getCLIDsStatus(array($callerid));
        if (!array_key_exists(0, $items->items)) {
            return null;
        }
        $clid_status = $items->items[0];
        return $clid_status;
    }

    /**
     * Returns CLIDs status
     * 
     * @param array $clids CLIDs
     * @param AdescomSoapClient $connection Connection
     * @return array CLIDs status
     */
    public function getCLIDsStatus(array $clids, AdescomSoapClient $connection = null)
    {
        if ($connection === null) {
            $connection = AdescomConnection::getConnection();
        }
        $response = $connection->getCLIDsStatus($clids);

        $results = array();

        if (is_array($response->items)) {
            foreach ($response->items as $clid_status) {
                $results[] = array(
                    'callerID' => $clid_status->callerID, 
                    'status' => $clid_status->status, 
                    'ip_address' => $clid_status->ipAddress, 
                    'port' => $clid_status->port,
                    'ctm_node_name' => $clid_status->nodeName,
                );
            }
        }

        return $results;
    }
    
    /**
     * Converts CLID array to CLID object
     * 
     * @param array $clid CLID
     * @return \stdClass CLID
     */
    static private function prepareCLIDData(array $clid)
    {
        global $DB;
        
        $number = new StdClass;
        $number->countryCode = $clid['countrycode'];
        $number->areaCode = $clid['areacode'];
        $number->shortCLID = $clid['shortclid'];

        $details = new stdClass();
        if (isset($clid['ownerid'])) {
            $details->clientExternalID = ArrayHelper::arrayGetValue('ownerid', $clid, null);
        }

        $details->clientID = null;
        if (isset($clid['clientid'])) {
            $details->clientExternalID = ArrayHelper::arrayGetValue('clientid', $clid, null);
        }
        $details->callerID = $number->countryCode . $number->areaCode . $number->shortCLID;
        $details->number = $number;
        $details->phoneID = $clid['phoneid'];
        $details->line = $clid['line'];
        $details->license = $clid['passwd'];
        $details->ctmID = $clid['ctmid'];
        $details->displayName = $clid['displayname'];
        $details->context = $clid['context'];
        if ($clid['emergencycontext_type'] === 'by_city') {
            $details->emergencyContext = $clid['emergencycontext_from_commune'];
        } else {
            $details->emergencyContext = $clid['emergencycontext'];
        }
        $details->host = $clid['host'];
        $details->hostName = $clid['hostname'];
        $details->isPrepaid = (boolean) $clid['is_prepaid'];
        $details->voicemailEnabled = (boolean) $clid['voicemail'];
        $details->voicemailPassword = $clid['voicemailpassword'];
        $details->voicemailAttachMessage = $clid['voicemailattach'];
        $details->registrationType = $clid['registration_type'];
        $details->email = $clid['email'];
        $details->macAddress = str_replace(array('-', ':', '.'), '', $clid['mac_address']);
        $details->serialNumber = $clid['serial_number'];
        $details->tariffID = $clid['tariffid'];
        $details->active = $clid['active'];

        $details->ported = $clid['ported'];
        $details->isPortedNumber = $clid['ported'];

        $details->autoactivationDate = $clid['autoactivation_date'];
        if (isset($clid['ported']) && $clid['ported'] == true) {
            $details->poolID = null;
        } else {
            $details->poolID = $clid['poolid'];
        }

        if (is_array($clid['blocklevels']) && !empty($clid['blocklevels'])) {
            $details->blockLevelEx = $clid['blocklevels'];
        } else {
            $details->blockLevel = null;
        }
        
        if (!empty($clid['location_street'])) {
            $location_street = $DB->getRow('
                SELECT ls.ident AS street_ident, lc.ident AS city_ident
                FROM location_streets ls
                JOIN location_cities lc ON ls.cityid = lc.id
                WHERE ls.id = ?',
                array($clid['location_street'])
            );
            $details->teryt_city = $location_street['city_ident'];
            $details->teryt_street = $location_street['street_ident'];
        } elseif (!empty($clid['location_city'])) {
            $location_city = $DB->getRow('
                SELECT ident
                FROM location_cities
                WHERE id = ?',
                array($clid['location_city'])
            );
            $details->teryt_city = $location_city['ident'];
        }
        
        return $details;
    }
    
    /**
     * Converts CLID object to CLID array
     * 
     * @param stdClass $clid CLID
     * @return array CLID
     */
    static private function getCLIDArray(stdClass $clid = null)
    {
        if ($clid === null) {
            return null;
        }

        $result = array();
        $result['callerid'] = $clid->callerID;
        $result['countrycode'] = $clid->number->countryCode;
        $result['areacode'] = $clid->number->areaCode;
        $result['shortclid'] = $clid->number->shortCLID;
        $result['phoneid'] = $clid->phoneID;
        $result['line'] = $clid->line;
        $result['passwd'] = $clid->license;
        $result['ctmid'] = $clid->ctmID;
        $result['displayname'] = $clid->displayName;
        $result['context'] = $clid->context;
        $result['emergencycontext'] = $clid->emergencyContext;
        $result['host'] = $clid->host;
        $result['hostname'] = $clid->hostName;
        $result['is_prepaid'] = $clid->isPrepaid;
        $result['voicemail'] = $clid->voicemailEnabled;
        $result['voicemailpassword'] = $clid->voicemailPassword;
        $result['voicemailattach'] = $clid->voicemailAttachMessage;
        $result['registration_type'] = $clid->registrationType;
        $result['email'] = $clid->email;
        $result['mac_address'] = $clid->macAddress;
        $result['serial_number'] = $clid->serialNumber;
        $result['tariffid'] = $clid->tariffID;
        $result['clientid'] = $clid->clientID;
        $result['clientextid'] = $clid->clientExternalID;
        $result['active'] = $clid->active;
        $result['deleted'] = $clid->deleted;
        $result['autoactivation_date'] = $clid->autoactivationDate;
        $result['ported'] = $clid->isPortedNumber;
        $result['blocklevels'] = is_array($clid->blockLevelEx) ? $clid->blockLevelEx : array();
        $result['poolid'] = $clid->poolID;
        $result['geoLocationCommuneID'] = $clid->geoLocationCommuneID;
        return $result;
    }

}
