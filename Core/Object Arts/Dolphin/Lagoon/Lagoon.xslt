<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:template match="/">
		<html>
			<head/>
			<body>
				<xsl:for-each select="Lagoon">
					<h1>Deployment Log</h1>
					<xsl:for-each select="Configuration">
						<xsl:if test="position()=1">
							<table border="0">
								<tbody>
									<tr>
										<td>
											<span style="font-weight:bold">Source:</span>
										</td>
										<xsl:for-each select="../Configuration">
											<td>
												<xsl:for-each select="ImagePath">
													<xsl:apply-templates/>
												</xsl:for-each>
											</td>
										</xsl:for-each>
									</tr>
									<tr>
										<td>
											<span style="font-weight:bold">Date:</span>
										</td>
										<xsl:for-each select="../Configuration">
											<td>
												<xsl:for-each select="TimeStamp">
													<xsl:apply-templates/>
												</xsl:for-each>
											</td>
										</xsl:for-each>
									</tr>
									<tr>
										<td>
											<span style="font-weight:bold">Target:</span>
										</td>
										<xsl:for-each select="../Configuration">
											<td>
												<xsl:for-each select="Target">
													<xsl:apply-templates/>
												</xsl:for-each>
											</td>
										</xsl:for-each>
									</tr>
								</tbody>
							</table>
						</xsl:if>
						<br/>
						<h2>Pre-Strip Image Statistics</h2>
						<xsl:for-each select="ImageStatistics">
							<xsl:if test="position()=1">
								<table border="1">
									<tbody>
										<tr>
											<td>Objects:</td>
											<xsl:for-each select="../ImageStatistics">
												<td>
													<xsl:for-each select="ObjectCount">
														<xsl:apply-templates/>
													</xsl:for-each>
												</td>
											</xsl:for-each>
										</tr>
										<tr>
											<td>Classes:</td>
											<xsl:for-each select="../ImageStatistics">
												<td>
													<xsl:for-each select="ClassCount">
														<xsl:apply-templates/>
													</xsl:for-each>
												</td>
											</xsl:for-each>
										</tr>
										<tr>
											<td>Methods:</td>
											<xsl:for-each select="../ImageStatistics">
												<td>
													<xsl:for-each select="MethodCount">
														<xsl:apply-templates/>
													</xsl:for-each>
												</td>
											</xsl:for-each>
										</tr>
										<tr>
											<td>Symbols</td>
											<xsl:for-each select="../ImageStatistics">
												<td>
													<xsl:for-each select="SymbolCount">
														<xsl:apply-templates/>
													</xsl:for-each>
												</td>
											</xsl:for-each>
										</tr>
									</tbody>
								</table>
							</xsl:if>
						</xsl:for-each>
						<br/>
						<br/>
						<xsl:for-each select="DevelopmentMethodCategories">
							<xsl:if test="position()=1">
								<table border="1">
									<thead>
										<tr>
											<td>MethodCategory</td>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each select="../DevelopmentMethodCategories">
											<tr>
												<td>
													<xsl:for-each select="MethodCategory">
														<xsl:apply-templates/>
													</xsl:for-each>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</xsl:if>
						</xsl:for-each>
						<br/>
						<br/>
						<xsl:for-each select="RequiredMethodCategories">
							<xsl:if test="position()=1">
								<table border="1">
									<thead>
										<tr>
											<td>MethodCategory</td>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each select="../RequiredMethodCategories">
											<tr>
												<td>
													<xsl:for-each select="MethodCategory">
														<xsl:apply-templates/>
													</xsl:for-each>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</xsl:if>
						</xsl:for-each>
						<br/>
						<br/>
						<xsl:for-each select="PreservedMessages">
							<xsl:if test="position()=1">
								<table border="1">
									<thead>
										<tr>
											<td>Selector</td>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each select="../PreservedMessages">
											<tr>
												<td>
													<xsl:for-each select="Selector">
														<xsl:apply-templates/>
													</xsl:for-each>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</xsl:if>
						</xsl:for-each>
						<br/>
					</xsl:for-each>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<xsl:for-each select="Manifest">
						<br/>
						<xsl:if test="position()=1">
							<table border="1">
								<tbody>
									<tr>
										<td>Total Instances</td>
										<xsl:for-each select="../Manifest">
											<td>
												<xsl:for-each select="TotalInstances">
													<xsl:apply-templates/>
												</xsl:for-each>
											</td>
										</xsl:for-each>
									</tr>
									<tr>
										<td>Total Methods</td>
										<xsl:for-each select="../Manifest">
											<td>
												<xsl:for-each select="TotalMethods">
													<xsl:apply-templates/>
												</xsl:for-each>
											</td>
										</xsl:for-each>
									</tr>
									<tr>
										<td>Total Class Methods</td>
										<xsl:for-each select="../Manifest">
											<td>
												<xsl:for-each select="TotalClassMethods">
													<xsl:apply-templates/>
												</xsl:for-each>
											</td>
										</xsl:for-each>
									</tr>
								</tbody>
							</table>
						</xsl:if>
						<xsl:for-each select="Classes">
							<xsl:if test="position()=1">
								<table border="1">
									<thead>
										<tr>
											<td>Class</td>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each select="../Classes">
											<tr>
												<td>
													<xsl:for-each select="Class">
														<xsl:if test="position()=1">
															<table border="1">
																<thead>
																	<tr>
																		<td>count</td>
																		<td>unbound</td>
																		<td>Name</td>
																		<td>Methods</td>
																		<td>ClassMethods</td>
																	</tr>
																</thead>
																<tbody>
																	<xsl:for-each select="../Class">
																		<tr>
																			<td>
																				<xsl:for-each select="@count">
																					<xsl:value-of select="."/>
																				</xsl:for-each>
																			</td>
																			<td>
																				<xsl:for-each select="@unbound">
																					<xsl:value-of select="."/>
																				</xsl:for-each>
																			</td>
																			<td>
																				<xsl:for-each select="Name">
																					<xsl:apply-templates/>
																				</xsl:for-each>
																			</td>
																			<td>
																				<xsl:for-each select="Methods">
																					<xsl:if test="position()=1">
																						<table border="1">
																							<tbody>
																								<xsl:for-each select="../Methods">
																									<tr>
																										<td>
																											<xsl:for-each select="Method">
																												<xsl:apply-templates/>
																											</xsl:for-each>
																										</td>
																									</tr>
																								</xsl:for-each>
																							</tbody>
																						</table>
																					</xsl:if>
																				</xsl:for-each>
																			</td>
																			<td>
																				<xsl:for-each select="ClassMethods">
																					<xsl:if test="position()=1">
																						<table border="1">
																							<tbody>
																								<xsl:for-each select="../ClassMethods">
																									<tr>
																										<td>
																											<xsl:for-each select="Method">
																												<xsl:apply-templates/>
																											</xsl:for-each>
																										</td>
																									</tr>
																								</xsl:for-each>
																							</tbody>
																						</table>
																					</xsl:if>
																				</xsl:for-each>
																			</td>
																		</tr>
																	</xsl:for-each>
																</tbody>
															</table>
														</xsl:if>
													</xsl:for-each>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
					<br/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="Class">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="ClassCount">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="ClassMethods">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="Classes">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="Configuration">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="DetailMessage">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="DevelopmentMethodCategories">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="GUID">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="ImagePath">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
