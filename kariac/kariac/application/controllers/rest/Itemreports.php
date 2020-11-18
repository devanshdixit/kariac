<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for News
 */
class Itemreports extends API_Controller
{

	/**
	 * Constructs Parent Constructor
	 */
	function __construct()
	{
		parent::__construct( 'Itemreport' );
	}

	/**
	 * Default Query for API
	 * @return [type] [description]
	 */
	function default_conds()
	{
		$conds = array();

		if ( $this->is_get ) {
		// if is get record using GET method

		}

		return $conds;
	}

	function add_post() {

		$item_id = $this->post('item_id');
		$is_paid = $this->Item->get_one($item_id)->is_paid;

		if ( $is_paid != "1" ) {
		  	$report_data = array(
		  		"item_id" => $item_id, 
	        	"reported_user_id" => $this->post('reported_user_id'),
		  	);
		

	  		$this->Itemreport->save($report_data);

	  		$this->success_response( get_msg( 'success_item_report'));
	  	} else {
	  		$this->error_response( get_msg( 'err_item_report'));
	  	}

	}

	/**
	 * Convert Object
	 */
	function convert_object( &$obj )
	{

		// call parent convert object
		parent::convert_object( $obj );
	}

}